{config, ...}: {
  services.caddy = {
    enable = config.niksos.server;
    email = "jurnwubben@gmail.com";
    enableReload = false;
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
