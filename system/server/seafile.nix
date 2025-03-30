{config, inputs, pkgs, ...}:{
  services.seafile = {
    enable = config.niksos.server;
    seahubPackage = inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.seahub;

    adminEmail = "jurnwubben@gmail.com";
    initialAdminPassword = "ChangeMeTheFuckNow!";

    gc.enable = true;

    ccnetSettings.General.SERVICE_URL = "https://files.jsw.tf";
    seahubExtraConf = ''
ALLOWED_HOSTS = ['.files.jsw.tf']
CSRF_COOKIE_SECURE = True
CSRF_COOKIE_SAMESITE = 'Strict'
CSRF_TRUSTED_ORIGINS = ['https://files.jsw.tf', 'https://www.files.jsw.tf']
    '';
    seafileSettings = {
      quota.default = 30;
      history.keep_days = 40;
      library_trash.expire_days = 14;
      fileserver = {
	host = "unix:/run/seafile/server.sock";
	web_token_expire_time = 14400; # 4 hours 
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
