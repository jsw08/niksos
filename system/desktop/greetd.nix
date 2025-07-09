{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.niksos.desktop.enable {
    # greetd display manager
    services.greetd = {
      enable = true;
      settings.terminal.vt = 1;
    };
  };
}
