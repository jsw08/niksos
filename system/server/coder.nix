{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.niksos) server;
  port = 9005;
  host = "coder.jsw.tf";
  httpsHost = "https://" + host;
in {
  config = lib.mkIf server {
    services = {
      caddy.virtualHosts."${host}".extraConfig = ''
        reverse_proxy :${port}
      '';
      coder = {
        enable = true;
        listenAddress = "127.0.0.1:${port}";
        wildcardAccessUrl = "*.${host}";
        accessUrl = httpsHost;
        environment = {
          file = ./file.file; # See format below.
          /*
          CODER_OIDC_CLIENT_ID=""
          CODER_OIDC_CLIENT_SECRET=""
          */
          extra = {
            CODER_OIDC_ISSUER_URL = "https://z.jsw.tf";
            # CODER_OIDC_EMAIL_DOMAIN="your-domain-1,your-domain-2";
          };
        };
      };
    };
  };
}
