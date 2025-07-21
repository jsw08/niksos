{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkForce;
  cfg = config.niksos.server;

  url = "files.jsw.tf";
  httpsUrl = "https://" + url;
  authUrl = config.services.zitadel.settings.ExternalDomain;
  httpsAuthUrl = "https://" + authUrl;
  oidcSubstitute = "*@#OPENIDCLIENTSECRET#@*";
in {
  config = mkIf cfg {
    services.caddy.virtualHosts.${url}.extraConfig = ''
           handle_path /seafhttp/* {
      reverse_proxy * unix//run/seafile/server.sock
           }
           handle_path /* {
      reverse_proxy * unix//run/seahub/gunicorn.sock
           }
    '';

    services.seafile = {
      enable = config.niksos.server;
      seahubPackage = inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.seahub;

      adminEmail = "jsw@jsw.tf";
      initialAdminPassword = "ChangeMeTheFuckNow!";

      gc.enable = true;

      ccnetSettings.General.SERVICE_URL = httpsUrl;
      seahubExtraConf = ''
        ALLOWED_HOSTS = ['.${url}']
        CSRF_COOKIE_SECURE = True
        CSRF_COOKIE_SAMESITE = 'Strict'
        CSRF_TRUSTED_ORIGINS = ['${httpsUrl}']

        SITE_NAME = "JSW Cloud"
        SITE_TITLE = "JSW Cloud"

        ENABLE_OAUTH = True
        OAUTH_CREATE_UNKNOWN_USER = True
        OAUTH_ACTIVATE_USER_AFTER_CREATION = True
        OAUTH_ENABLE_INSECURE_TRANSPORT = False
        OAUTH_CLIENT_ID = "329743411726844274"
        OAUTH_CLIENT_SECRET = "${oidcSubstitute}"
        OAUTH_REDIRECT_URL = '${httpsUrl}/oauth/callback/'
        OAUTH_PROVIDER_DOMAIN = '${authUrl}'
        OAUTH_PROVIDER = 'JSW Auth'
        OAUTH_AUTHORIZATION_URL = '${httpsAuthUrl}/oauth/v2/authorize'
        OAUTH_TOKEN_URL = '${httpsAuthUrl}/oauth/v2/token'
        OAUTH_USER_INFO_URL = '${httpsAuthUrl}/oidc/v1/userinfo'
        OAUTH_SCOPE = ["user",]
        OAUTH_ATTRIBUTE_MAP = {
            "id": (True, "email"),
            "name": (False, "name"),
            "email": (False, "contact_email"),
            "uid": (True, "uid"),
        }
      '';
      seafileSettings = {
        quota.default = 30;
        history.keep_days = 40;
        library_trash.expire_days = 14;
        fileserver = {
          host = "unix:/run/seafile/server.sock";
          web_token_expire_time = 14400; # 4 hours
          max_download_dir_size = 100000; # 100gb max download size.
        };
      };
    };

    #NOTE: Overwriting parts of services so that it uses a different root. When upgrading. Please check the following two things:
    ## * If seafile still uses seafile_settings.py to store openid settings.systemd
    ## * If the service scripts / settings have changed.systemd
    ## * Better even, rewrite this entire part.
    systemd.services = let
      config-dir = "/run/seafile";
      replaceSecretBin = lib.getExe pkgs.replace-secret;
      seafRoot = "/var/lib/seafile";
      ccnetDir = "${seafRoot}/ccnet";
      sfCfg = config.services.seafile;
    in {
      seaf-server = {
        preStart = ''
          umask 077
          cp -f '/etc/seafile' '${config-dir}'
          chmod u+w -R '${config-dir}'
          ${replaceSecretBin} '${oidcSubstitute}' '${config.age.secrets.seafile-oidc.path}' '${config-dir}/seahub_settings.py'
        '';
        serviceConfig.ExecStart = mkForce ''
          ${lib.getExe sfCfg.seahubPackage.seafile-server} \
          --foreground \
          -F '${config-dir} \
          -c ${ccnetDir} \
          -d ${sfCfg.dataDir} \
          -l /var/log/seafile/server.log \
          -P /run/seafile/server.pid \
          -p /run/seafile
        '';
      };
      seahub.environment.SEAFILE_CENTRAL_CONF_DIR = mkForce config-dir;
    };
  };
}
