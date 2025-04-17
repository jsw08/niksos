{config, lib, ...}: let
  cfg = config.niksos.server;
in {
  services.immich = {
    enable = cfg;

    port = 9002;
    machine-learning.enable = false;

    settings = {
      server.externalDomain = "https://photos.jsw.tf";
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

    accelerationDevices = lib.mkDefault null;
  };
  users.users.immich.extraGroups = lib.mkIf cfg ["video" "render"];

  services.caddy.virtualHosts."photos.jsw.tf" = {
    extraConfig = ''
      reverse_proxy localhost:9002
    '';
  };
}
