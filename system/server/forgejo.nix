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
        reverse_proxy unix/${config.services.forgejo.settings.server.HTTP_ADDR}
      '';

      services.forgejo = {
        enable = true;
        database.type = "postgres";
        lfs.enable = true;

        settings = {
          server = {
            inherit DOMAIN;
            ROOT_URL = "https://${DOMAIN}/";
            PROTOCOL = "http+unix";
            DISABLE_SSH = true;
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
            DESCRIPTION = "Jsw's Git Forge, a self-hosted Forgejo instance.";
            KEYWORDS = "jsw,jsw08,jurnwubben,jurn,git,gitea,forgejo,forge";
          };
          actions = {
            ENABLED = true;
            DEFAULT_ACTIONS_URL = "github";
          };
          mailer = {
            ENABLED = true;
            SUBJECT_PREFIX = "JSWGit";
            PROTOCOL = "smtps";
            SMTP_ADDR = "mail.jsw.tf"; #FIXME: replace with config... to stalwart setting once using stalwart nixos module.
            SMTP_PORT = 465;
            FROM = "git@jsw.tf";
            USER = "git";
            PASSWD_URI = "file:${config.age.secrets.forgejo-mailpass.path}";
          };
        };
      };
    };
}
