{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkForce mkDefault;

  cfg = config.niksos.server;
  oidcSubstitute = "*@#OPENIDCLIENTSECRET#@*";
  config-dir = "/run/immich-conf";
in {
  config =
    mkIf cfg
    {
      users.users.${config.services.immich.user}.extraGroups = ["video" "render"];
      services.caddy.virtualHosts."photos.jsw.tf".extraConfig = ''
        reverse_proxy localhost:9002
      '';

      services.immich = mkIf cfg {
        enable = true;

        port = 9002;
        machine-learning.enable = false;

        accelerationDevices = mkDefault null;

        #NOTE: immich doesn't support variables in their config file, so we have to subsitute ourselfs..
        environment.IMMICH_CONFIG_FILE = mkForce "${config-dir}/immich.json";
        settings = {
          server.externalDomain = "https://photos.jsw.tf";
          oauth = {
            enabled = true;
            autoLaunch = true;
            autoRegister = true;
            buttonText = "Login with JSWAuth";
            clientId = "329735769805619570";
            clientSecret = oidcSubstitute;
            issuerUrl = "https://${config.services.zitadel.settings.ExternalDomain}/.well-known/openid-configuration";
          };
          passwordLogin.enabled = false;
          ffmpeg = {
            crf = 23;
            threads = 0;
            preset = "ultrafast";
            targetVideoCodec = "h264";
            acceptedVideoCodecs = [
              "h264"
            ];
            targetAudioCodec = "aac";
            acceptedAudioCodecs = [
              "aac"
              "mp3"
              "libopus"
              "pcm_s16le"
            ];
            acceptedContainers = [
              "mov"
              "ogg"
              "webm"
            ];
            targetResolution = "720";
            maxBitrate = "0";
            bframes = -1;
            refs = 0;
            gopSize = 0;
            temporalAQ = false;
            cqMode = "auto";
            twoPass = false;
            preferredHwDevice = lib.mkDefault "auto";
            transcode = "all";
            tonemap = "hable";
            accel = lib.mkDefault "vaapi";
            accelDecode = true;
          };
        };
      };

      systemd = {
        services.immich-server = {
          preStart = let
            refConfig = (pkgs.formats.json {}).generate "immich.json" config.services.immich.settings;
            newConfig = "${config-dir}/immich.json";
            replaceSecretBin = "${pkgs.replace-secret}/bin/replace-secret";
          in ''
            umask 077
            cp -f '${refConfig}' '${newConfig}'
            chmod u+w '${newConfig}'
            ${replaceSecretBin} '${oidcSubstitute}' '${config.age.secrets.immich-oidc.path}' '${newConfig}'
          '';
        };
        tmpfiles.rules = [
          "d ${config-dir} 0700 immich immich"
        ];
      };
    };
}
