{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe;
in {
  programs.fuzzel = {
    enable = false; #NOTE: Fuzzel is disabled.
    # inherit (osConfig.programs.hyprland) enable;
    settings.main = {
      launch-prefix = "${lib.getExe pkgs.uwsm} app --";
      terminal = "${getExe pkgs.foot}";
    };
  };
}
