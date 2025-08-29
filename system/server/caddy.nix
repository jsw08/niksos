{
  config,
  lib,
  ...
}: let
  inherit (config.services.caddy) enable;
  inherit (lib) mkIf;
in {
  config = mkIf enable {
    services.caddy = {
      email = "jurnwubben@gmail.com";
      enableReload = false;
    };

    networking.firewall.allowedTCPPorts = [80 443];
  };
}
