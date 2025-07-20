{config, ...}: let
  serviceUser = x: config.systemd.services.${x}.serviceConfig.User;
in {
  age.secrets = {
    transferSh = {
      file = ./transfer-sh.age;
      owner = "jsw";
    };
    dcbot = {
      file = ./dcbot.age;
      owner =
        if config.niksos.server
        then serviceUser "dcbot" # "dcbot" doesn't exist on e.g laptop.
        else "root";
    };
    bread-dcbot = {
      file = ./bread-dcbot.age;
      owner =
        if config.niksos.server
        then serviceUser "bread-dcbot" # "dcbot" doesn't exist on e.g laptop.
        else "root";
    };
    password.file = ./password.age;
    matrix-registration = {
      file = ./matrix-registration.age;
      owner =
        if config.niksos.server
        then config.services.matrix-continuwuity.user
        else "root";
    };
    cloudflare-acme.file = ./cloudflare-acme.age;
    mail-admin = {
      # owner = #FIXME: revert when stopped using docker for stalwart.
      #   if config.niksos.server
      #   then serviceUser "stalwart-mail"
      #   else "root";
      file = ./mail-admin.age;
    };
    zitadel.file = ./zitadel.age;
  };
}
