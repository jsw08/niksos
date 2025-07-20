{
  config,
  lib,
  ...
}: let
  DOMAIN = "git.jsw.tf";
in {
  config =
    lib.mkIf config.niksos.server
    {
      services.caddy.virtualHosts.${DOMAIN}.extraConfig = ''
        request_body {
            max_size 512M
        }
        reverse_proxy localhost:9004
      '';

      services.forgejo = {
        enable = true;
        database.type = "postgres";
        lfs.enable = true;

        settings = {
          server = {
            inherit DOMAIN;
            ROOT_URL = "https://${DOMAIN}/";
            HTTP_PORT = 9004;
          };
          service = {
            DISABLE_REGISTRATION = true;
            EnableInternalSignIn = false;
          };
          actions = {
            ENABLED = true;
            DEFAULT_ACTIONS_URL = "github";
          };
        };
      };
    };
}
