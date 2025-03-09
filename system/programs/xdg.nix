{
  pkgs,
  config,
  lib,
  ...
}: {
  xdg.portal = lib.mkIf config.niksos.desktop {
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
