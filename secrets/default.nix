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
    dcbot = mkIf server {
      file = ./dcbot.age;
      owner = serviceUser "dcbot"; #
    };
    bread-dcbot = mkIf server {
      file = ./bread-dcbot.age;
      owner = "bread-dcbot";
    };
    matrix-registration = mkIf server {
      file = ./matrix-registration.age;
      owner = abstrServiceUser "matrix-continuwuity";
    };
    mail-admin = mkIf server {
      # owner = serviceUser "stalwart-mail"; #FIXME: revert when stopped using docker for stalwart.
      file = ./mail-admin.age;
    };
    zitadel-key = mkIf server {
      file = ./zitadel-key.age;
      owner = abstrServiceUser "zitadel";
    };
    forgejo-mailpass = mkIf server {
      file = ./forgejo-mailpass.age;
      owner = abstrServiceUser "forgejo";
    };
    immich-oidc = mkIf server {
      file = ./immich-oidc.age;
      owner = abstrServiceUser "immich";
    };
  };
}
