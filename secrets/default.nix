{
  config,
  lib,
  ...
}: let
  inherit (config.niksos) server;

  isEnabled = x: lib.mkIf server.${x}.enable;
  serviceUser = x: config.systemd.services.${x}.serviceConfig.User;
  abstrServiceUser = x: config.services.${x}.user;
  abstrServiceGroup = x: config.services.${x}.group;
in {
  age.secrets = {
    password.file = ./password.age;

    # NOTE: server things
    jsw-bot = isEnabled "jsw-bot" {
      file = ./jsw-bot.age;
      owner = serviceUser "jsw-bot"; #
    };
    derek-bot = isEnabled "derek-bot" {
      file = ./derek-bot.age;
      owner = "derek-bot";
    };
    derek-site = isEnabled "derek-site" {
      file = ./derek-site.age;
      owner = "derek-site";
    };
    # matrix-registration = isEnabled "matrix" {
    #   file = ./matrix-registration.age;
    #   owner = abstrServiceUser "matrix-continuwuity";
    # };
    mail-admin = isEnabled "stalwart" {
      # owner = serviceUser "stalwart-mail"; #FIXME: revert when stopped using docker for stalwart.
      file = ./mail-admin.age;
    };
    zitadel-key = isEnabled "zitadel" {
      file = ./zitadel-key.age;
      owner = abstrServiceUser "zitadel";
    };
    forgejo-mailpass = isEnabled "forgejo" {
      file = ./forgejo-mailpass.age;
      owner = abstrServiceUser "forgejo";
    };
    immich-oidc = isEnabled "immich" {
      file = ./immich-oidc.age;
      owner = abstrServiceUser "immich";
    };
    nextcloud-admin-pass = isEnabled "nextcloud" {
      file = ./nextcloud-admin-pass.age;
      owner = "nextcloud"; #NOTE: not a clear 'nextcloud.service' or 'services.nextcloud.user'.
    };
  };
}
