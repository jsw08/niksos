{
  osConfig,
  pkgs,
  lib,
  ...
}: {
  programs.fuzzel = {
    enable = osConfig.niksos.desktop.hyprland;
    settings.main = {
      launch-prefix = "${lib.getExe pkgs.uwsm} app --";
    };
  };
}
