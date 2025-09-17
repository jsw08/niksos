{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.niksos) hardware desktop;
  inherit (lib) mkIf;
  uwsm = lib.getExe pkgs.uwsm;
  foot = lib.getExe pkgs.foot;
  hypr = config.programs.hyprland.enable;
in {
  config = mkIf hardware.fingerprint {
    services = {
      fprintd.enable = true;
      logind.settings.Login = mkIf hypr {
        # don’t shutdown when power button is short-pressed
        HandlePowerKey = "ignore";
      };
    };

    home-manager.users.jsw.wayland.windowManager.hyprland.settings = mkIf hypr {
      bind = [
        ", XF86PowerOff, exec, ${uwsm} app -- pgrep fprintd-verify && exit 0 || ${foot} -a 'foot-fprintd' sh -c 'fprintd-verify && systemctl sleep'"
      ];
      windowrule = [
        "float, class:foot-fprintd"
      ];
    };
  };
}
