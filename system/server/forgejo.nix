{
  config,
  lib,
  ...
}: let
  name = "forgejo";
  cfg = import ./lib/extractWebOptions.nix {inherit config name;};

  DOMAIN = cfg.domain;
in {
  options = import ./lib/webOptions.nix {inherit config lib name;};
  config =
    lib.mkIf cfg.enable
    {
      services.caddy = {
        enable = true;
        virtualHosts.${DOMAIN}.extraConfig = ''
          request_body {
              max_size 512M
          }
          reverse_proxy unix/${config.services.forgejo.settings.server.HTTP_ADDR}
        '';
      };

      services.forgejo = {
        enable = true;
        database.type = "postgres";
        lfs.enable = true;

        settings = {
          default = {
            APP_NAME = "JSW Git";
            APP_SLOGAN = "We be gitting.";
          };

          cors.ENABLED = true;
          server = {
            inherit DOMAIN;
            ROOT_URL = "https://${DOMAIN}/";
            PROTOCOL = "http+unix";
            DISABLE_SSH = true;
            LANDING_PAGE = "explore";
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
            #FIXME: Only enable if stalwart is enabled by default.
            ENABLED = true;
            SUBJECT_PREFIX = "JSWGit";
            PROTOCOL = "smtps";
            SMTP_ADDR = "mail.${cfg.baseDomain}"; #FIXME: replace with config... to stalwart setting once using stalwart nixos module.
            SMTP_PORT = 465;
            FROM = "git@${cfg.baseDomain}";
            USER = "git";
            PASSWD_URI = "file:${config.age.secrets.forgejo-mailpass.path}";
          };
        };
      };
    };
}
