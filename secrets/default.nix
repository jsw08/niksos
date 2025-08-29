{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.niksos) server;

  serviceUser = x: config.systemd.services.${x}.serviceConfig.User;
  abstrServiceUser = x: config.services.${x}.user;
  abstrServiceGroup = x: config.services.${x}.group;
in {
  age.secrets = {
    password.file = ./password.age;

    # NOTE: server things
    jsw-bot = mkIf server.jsw-bot.enable {
      file = ./jsw-bot.age;
      owner = serviceUser "jsw-bot"; #
    };
    derek-bot = mkIf server.derek-bot.enable {
      file = ./derek-bot.age;
      owner = "derek-bot";
    };
    # matrix-registration = mkIf server.matrix.enable {
    #   file = ./matrix-registration.age;
    #   owner = abstrServiceUser "matrix-continuwuity";
    # };
    mail-admin = mkIf server.stalwart.enable {
      # owner = serviceUser "stalwart-mail"; #FIXME: revert when stopped using docker for stalwart.
      file = ./mail-admin.age;
    };
    zitadel-key = mkIf server.zitadel.enable {
      file = ./zitadel-key.age;
      owner = abstrServiceUser "zitadel";
    };
    forgejo-mailpass = mkIf server.forgejo.enable {
      file = ./forgejo-mailpass.age;
      owner = abstrServiceUser "forgejo";
    };
    immich-oidc = mkIf server.immich.enable {
      file = ./immich-oidc.age;
      owner = abstrServiceUser "immich";
    };
    nextcloud-admin-pass = mkIf server.nextcloud.enable {
      file = ./nextcloud-admin-pass.age;
      owner = "nextcloud"; #NOTE: not a clear 'nextcloud.service' or 'services.nextcloud.user'.
    };
  };
}
