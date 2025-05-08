{
  config,
  lib,
  ...
}: let
  cfg = config.niksos.server;
in {
  services.caddy = {
    enable = cfg;
    email = "jurnwubben@gmail.com";
    enableReload = false;
  };

  networking.firewall.allowedTCPPorts = lib.mkIf cfg [80 443];
}
