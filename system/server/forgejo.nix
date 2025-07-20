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
            ENABLE_INTERNAL_SIGNIN = false;
            # DISABLE_REGISTRATION = true;
            ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
          };
          oauth2_client = {
            ENABLE_AUTO_REGISTRATION = true;
          };
          "ui.meta" = {
            AUTHOR = "JSW Git";
            DESCRIPTION = "Personal GIT-Forgejo instance.";
          };
          actions = {
            ENABLED = true;
            DEFAULT_ACTIONS_URL = "github";
          };
          mailer = {
            ENABLED = true;
            SUBJECT_PREFIX = "JSWGit";
            PROTOCOL = "smtps";
            SMTP_ADDR = "mail.jsw.tf";
            SMTP_PORT = 465;
            FROM = "git@jsw.tf";
            USER = "git";
            PASSWD_URI = "file:${config.age.secrets.forgejo-mailpass.path}";
          };
        };
      };
    };
}
