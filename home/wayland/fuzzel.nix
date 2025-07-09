{
  osConfig,
  pkgs,
  lib,
  ...
}: {
  programs.fuzzel = {
    inherit (osConfig.programs.hyprland) enable;
    settings.main = {
      launch-prefix = "${lib.getExe pkgs.uwsm} app --";
    };
  };
}
