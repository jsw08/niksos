{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;

  uwsm = getExe pkgs.uwsm;
  hyprlock = getExe pkgs.hyprlock;
in {
  imports = [
    ./binds.nix
    ./settings.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      env = [
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      ];
      exec-once = [
        "${uwsm} finalize"
        "${hyprlock}" # Lock screen
      ];
    };
  };
}
