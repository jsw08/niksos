{
  config,
  inputs,
  pkgs,
  ...
}: let
  url = "files.jsw.tf";
  httpsUrl = "https://" + url;
  authUrl = config.services.zitadel.settings.ExternalDomain;
  httpsAuthUrl = "https://" + authUrl;
  oidcSubstitute = "*@#OPENIDCLIENTSECRET#@*";
  config-dir = "/run/immich-conf";
in {
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

  services.caddy.virtualHosts.${url} = {
    extraConfig = ''
           handle_path /seafhttp/* {
      reverse_proxy * unix//run/seafile/server.sock
           }
           handle_path /* {
      reverse_proxy * unix//run/seahub/gunicorn.sock
           }
    '';
  };
}
