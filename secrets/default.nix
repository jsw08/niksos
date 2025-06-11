{config, ...}: {
  age.secrets = {
    transferSh = {
      file = ./transfer-sh.age;
      owner = "jsw";
    };
    dcbot = {
      file = ./dcbot.age;
      owner =
        if config.niksos.server
        then "dcbot" # "dcbot" doesn't exist on e.g laptop.
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
  };
}
