{config, ...}: {
  services.stalwart-mail = {
    enable = true;
    openFirewall = false; # Don't want to open port 8080, will leave that for caddy.
    credentials = {
      user_admin_password = config.age.secrets.mail-admin.path;
    };
    settings = {
      authentication = {
        fallback-admin = {
          secret = "%{file:/run/credentials/stalwart-mail.service/user_admin_password}%";
          user = "admin";
        };
      };
      server = {
        tracer."log" = {
          ansi = false;
          enable = true;
          level = "info";
          path = "./stalwart/logs";
          prefix = "stalwart.log";
          rotate = "daily";
          type = "log";
        };
        listener = {
          http = {
            bind = "127.0.0.1:9003";
            protocol = "http";
          };
          imaptls = {
            bind = "[::]:993";
            protocol = "imap";
            tls.implicit = true;
          };
          smtp = {
            bind = "[::]:25";
            protocol = "smtp";
          };
          submissions = {
            bind = "[::]:465";
            protocol = "smtp";
            tls.implicit = true;
          };
        };
      };

      hostname = "mx1.jsw.tf";
      lookup.default = {
        hostname = "mx1.jsw.tf";
        domain = "jsw.tf";
      };
      acme."letsencrypt" = {
        directory = "https://acme-v02.api.letsencrypt.org/directory";
        challenge = "tls-alpn-01";
        contact = ["jurnwubben@gmail.com"];
        domains = ["jsw.tf" "mx1.jsw.tf"];
        cache = "%{BASE_PATH}%/etc/acme";
        renew-before = "30d";
      };
      directory."imap".lookup.domains = ["jsw.tf"];
      # directory."in-memory" = {
      #   type = "memory";
      #   principals = [
      #     {
      #       class = "individual";
      #       name = "User 1";
      #       secret = "%{file:/etc/stalwart/mail-pw1}%";
      #       email = [""];
      #     }
      #   ];
      # };
    };
  };
  networking.firewall.allowedTCPPorts = [
    993
    25
    465
  ];

  services.caddy.virtualHosts = {
    "webadmin.jsw.tf" = {
      extraConfig = ''
        reverse_proxy http://127.0.0.1:9003
      '';
      serverAliases = [
        "mta-sts.jsw.tf"
        "autoconfig.jsw.tf"
        "autodiscover.jsw.tf"
        "mail.jsw.tf"
      ];
    };
  };
}
