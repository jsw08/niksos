{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.niksos.desktop.enable && config.niksos.desktop.hyprland.enable;
in {
  config = lib.mkIf cfg {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
    environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Makes electron apps use wayland.
  };
}
