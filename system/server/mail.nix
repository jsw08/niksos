{config, ...}: {
  # nixpkgs.overlays = [
  #   (final: prev: let
  #     version = "0.12.4";
  #     hash = "sha256-MUbWGBbb8+b5cp+M5w27A/cHHkMcoEtkN13++FyBvbM=";
  #     cargoHash = "sha256-G1c7hh0nScc4Cx7A1UUXv6slA6pP0fC6h00zR71BJIo=";
  #   in {
  #     stalwart-mail = prev.stalwart-mail.overrideAttrs (new: old: rec {
  #       inherit cargoHash version;
  #       src = prev.fetchFromGitHub {
  #         inherit version hash;
  #         inherit (old.src) owner repo;
  #         tag = "v${version}";
  #       };
  #       cargoDeps = prev.rustPlatform.fetchCargoVendor {
  #         inherit src;
  #         hash = cargoHash;
  #       };
  #     });
  #   })
  # ];
  # services.stalwart-mail = {
  #   enable = true;
  #   openFirewall = false; # Don't want to open port 8080, will leave that for caddy.
  #   credentials = {
  #     user_admin_password = config.age.secrets.mail-admin.path;
  #   };
  #   settings = {
  #     authentication.fallback-admin = {
  #       secret = "%{file:/run/credentials/stalwart-mail.service/user_admin_password}%";
  #       user = "admin";
  #     };
  #     server = {
  #       tracer."log" = {
  #         ansi = false;
  #         enable = true;
  #         level = "info";
  #         path = "./stalwart/logs";
  #         prefix = "stalwart.log";
  #         rotate = "daily";
  #         type = "log";
  #       };
  #       listener = {
  #         bind = "127.0.0.1:9003";
  #         protocol = "http";
  #       };
  #       imaptls = {
  #         bind = "[::]:993";
  #         protocol = "imap";
  #         tls.implicit = true;
  #       };
  #       smtp = {
  #         bind = "[::]:25";
  #         protocol = "smtp";
  #       };
  #       submissions = {
  #         bind = "[::]:465";
  #         protocol = "smtp";
  #         tls.implicit = true;
  #       };
  #     };
  #   };
  #
  #   hostname = "mx1.jsw.tf";
  #   lookup.default.domain = "jsw.tf";
  #   acme."letsencrypt" = {
  #     directory = "https://acme-v02.api.letsencrypt.org/directory";
  #     challenge = "tls-alpn-01";
  #     contact = ["jurnwubben@gmail.com"];
  #     domains = ["jsw.tf" "mx1.jsw.tf"];
  #     renew-before = "30d";
  #   };
  #   directory."imap".lookup.domains = ["jsw.tf"];
  #   # directory."in-memory" = {
  #   #   type = "memory";
  #   #   principals = [
  #   #     {
  #   #       class = "individual";
  #   #       name = "User 1";
  #   #       secret = "%{file:/etc/stalwart/mail-pw1}%";
  #   #       email = [""];
  #   #     }
  #   #   ];
  #   # };
  # };

  #FIXME: revert when stopped using docker for stalwart. https://github.com/NixOS/nixpkgs/issues/416091

  virtualisation.oci-containers.containers.stalwart = {
    image = "docker.io/stalwartlabs/stalwart:latest";
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    ports = ["25:25" "465:465" "993:993" "9003:8080"];
    volumes = [
      "/opt/stalwart:/opt/stalwart"
    ];
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
        # "mta-sts.jsw.tf"
        # "autoconfig.jsw.tf"
        # "autodiscover.jsw.tf"
        "mail.jsw.tf"
      ];
    };
  };
}
