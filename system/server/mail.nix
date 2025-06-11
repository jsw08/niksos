{config, ...}: {
  services.stalwart-mail = {
    enable = true;
    openFirewall = true;
    settings = {
      server = {
        hostname = "mx1.jsw.tf";
        tls = {
          enable = true;
          implicit = true;
        };
        listener = {
          smtp = {
            protocol = "smtp";
            bind = "[::]:25";
          };
          submissions = {
            bind = "[::]:465";
            protocol = "smtp";
          };
          imaps = {
            bind = "[::]:993";
            protocol = "imap";
          };
          jmap = {
            bind = "[::]:8080";
            url = "https://mail.jsw.tf";
            protocol = "jmap";
          };
          management = {
            bind = ["127.0.0.1:8080"];
            protocol = "http";
          };
        };
      };
      lookup.default = {
        hostname = "mx1.jsw.tf";
        domain = "jsw.tf";
      };
      acme."letsencrypt" = {
        directory = "https://acme-v02.api.letsencrypt.org/directory";
        challenge = "dns-01";
        contact = "jswmail@proton.me";
        domains = ["jsw.tf" "mx1.jsw.tf"];
        provider = "cloudflare";
        secret = "%{file:${config.age.secrets.cloudflare-acme.path}}%";
      };
      session.auth = {
        mechanisms = "[plain]";
        directory = "'in-memory'";
      };
      storage.directory = "in-memory";
      session.rcpt.directory = "'in-memory'";
      queue.outbound.next-hop = "'local'";
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
      authentication.fallback-admin = {
        user = "admin";
        secret = "%{file:${config.age.secrets.password.path}}%";
      };
    };
  };

  services.caddy.virtualHosts = {
    "webadmin.jsw.tf" = {
      extraConfig = ''
        reverse_proxy http://127.0.0.1:8080
      '';
      serverAliases = [
        "mta-sts.example.org"
        "autoconfig.example.org"
        "autodiscover.example.org"
        "mail.example.org"
      ];
    };
  };
}
