{inputs, pkgs, ...}: {
  services.seafile = {
    enable = true;
    seahubPackage = inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.seahub;

    adminEmail = "jurnwubben@gmail.com";
    initialAdminPassword = "test";

    ccnetSettings.General.SERVICE_URL = "https://files.jsw.tf";

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
