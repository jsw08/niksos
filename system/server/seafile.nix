{
  config,
  inputs,
  pkgs,
  ...
}: {
  services.seafile = {
    enable = config.niksos.server;
    seahubPackage = inputs.nixpkgs.legacyPackages.${pkgs.system}.seahub;

    adminEmail = "jurnwubben@gmail.com";
    initialAdminPassword = "ChangeMeTheFuckNow!";

    gc.enable = true;

    ccnetSettings.General.SERVICE_URL = "https://files.jsw.tf";
    seahubExtraConf = ''
      ALLOWED_HOSTS = ['.files.jsw.tf']
      CSRF_COOKIE_SECURE = True
      CSRF_COOKIE_SAMESITE = 'Strict'
      CSRF_TRUSTED_ORIGINS = ['https://files.jsw.tf', 'https://www.files.jsw.tf']

      SITE_NAME = "JSW Cloud"
      SITE_TITLE = "JSW Cloud"
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

  services.caddy.virtualHosts."files.jsw.tf" = {
    # serverAliases = ["www.share.jsw.tf"];
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
