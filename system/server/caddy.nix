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

    globalConfig = ''
      http_port 80
      https_port 443
      auto_https off
    '';
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
