{
  config,
  lib,
  ...
}: let
  cfg = config.niksos.desktop.enable && config.niksos.desktop.hyprland;
in {
  config = lib.mkIf cfg {
    # greetd display manager
    services.greetd = let
      session = {
        command = "${lib.getExe config.programs.uwsm.package} start hyprland-uwsm.desktop";
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

    programs.uwsm.enable = true;
  };
}
