{inputs, pkgs, ...}: {
  services.seafile = {
    enable = true;
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
      fileserver = {
        host = "unix:/run/seafile/server.sock";
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
