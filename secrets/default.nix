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

    wg-lapserv-private.file = ./wg-lapserv-private.age;
    wg-laptop-private.file = ./wg-laptop-private.age;
  };
}
