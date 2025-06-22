{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.niksos.desktop.enable {
    # greetd display manager
    services.greetd = let
      session = {
        command = lib.mkDefault "${lib.getExe config.programs.uwsm.package} start hyprland-uwsm.desktop";
        user = "jsw";
      };
    in {
      enable = true;

      settings = {
        terminal.vt = 1;
        default_session = session;
        initial_session = session;
      };
    };

    programs.uwsm.enable = lib.mkDefault true;
  };
}
