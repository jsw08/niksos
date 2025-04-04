{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.niksos.desktop {
    # greetd display manager
    services.greetd = let
      session = {
        command = "${lib.getExe config.programs.uwsm.package} start hyprland-uwsm.desktop";
        user = "jsw";
      };
    in {
      enable = true;

      settings = lib.mkDefault {
        terminal.vt = 1;
        default_session = session;
        initial_session = session;
      };
    };

    programs.uwsm.enable = true;
  };
}
