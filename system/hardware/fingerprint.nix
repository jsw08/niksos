{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.niksos) fingerprint desktop;
  inherit (lib) mkIf mkEnableOption;
  uwsm = lib.getExe pkgs.uwsm;
  foot = lib.getExe pkgs.foot;
in {
  #NOTE: Also check home/wayland/hyprland/settings + home/wayland/hyprland/binds

  options.niksos.fingerprint = mkEnableOption "fingerprint support.";
  config = mkIf fingerprint {
    services.fprintd.enable = true;

    home-manager.users.jsw.wayland.windowManager.hyprland.settings = mkIf desktop.hyprland {
      bind = mkIf fingerprint [
        ", XF86PowerOff, exec, ${uwsm} app -- pgrep fprintd-verify && exit 0 || ${foot} -a 'foot-fprintd' sh -c 'fprintd-verify && systemctl sleep'"
      ];
      windowrule = [
        "float, class:foot-fprintd"
      ];
    };
  };
}
