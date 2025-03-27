{config, ...}: {
  services.caddy = {
    enable = config.niksos.server;
    email = "jurnwubben@gmail.com";
    enableReload = false;

    virtualHosts."share.jsw.tf" = {
      serverAliases = ["www.share.jsw.tf"];
      extraConfig = ''
        reverse_proxy :9000
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
