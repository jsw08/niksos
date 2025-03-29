{
  inputs,
  pkgs,
  ...
}: {
  services.seafile = {
    enable = true;
    seahubPackage = inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.seahub; # Unstable build fails.

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
      reverse_proxy unix//run/seahub/gunicorn.sock {
        header_up X-Real-IP {remote}
        header_up X-Forwarded-For {remote}
        header_up X-Forwarded-Host {host}

        transport http {
            respond_timeout 1200s
        }
      }


      # Reverse proxy for the Seafile file server
      reverse_proxy unix//run/seafile/server.sock {
        header_up X-Forwarded-For {remote}
        transport http {
          respond_timeout 36000s
        }

        rewrite * /seafhttp{uri}
      }
    '';
  };

  nixpkgs.config.allowBroken = true;
}
