{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.niksos.desktop.enable && config.niksos.desktop.hyprland;
in {
  xdg.portal = lib.mkIf cfg {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = ["gtk"];
      hyprland.default = ["gtk" "hyprland"];
    };

    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
