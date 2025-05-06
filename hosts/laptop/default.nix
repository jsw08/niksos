{
  pkgs,
  lib,
  inputs,
  ...
}: let
  uwsm = lib.getExe pkgs.uwsm;
  foot = lib.getExe pkgs.foot;
in {
  imports = [
    ./hardware-configuration.nix
    ./virt.nix
  ];

  niksos = {
    bluetooth = true;
    fingerprint = true;
    games = true;
    desktop = true;
    portable = true;
    neovim = true;
  };

  home-manager.users.jsw.wayland.windowManager.hyprland.settings = {
    monitor = ["eDP-1,2880x1920@120,0x0,1.5,vrr,1"];
    bind = [
      ", XF86PowerOff, exec, ${uwsm} app -- pgrep fprintd-verify && exit 0 || ${foot} -a 'foot-fprintd' sh -c 'fprintd-verify && systemctl sleep'"
    ];
    windowrulev2 = [
      # FIXME: change to `windowrule` after hyprland update.
      "float, class:foot-fprintd"
    ];
  };

  services = {
    usbmuxd.enable = true;
    joycond.enable = true;
    udev.extraRules = ''
      # Ethernet expansion card support
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/autosuspend}="20"
    '';
    logind.extraConfig = ''
      # don’t shutdown when power button is short-pressed
      HandlePowerKey=ignore
    '';
  };
  hardware.sensor.iio.enable = true; # brightness sensor

  boot.kernelParams = [
    # There seems to be an issue with panel self-refresh (PSR) that
    # causes hangs for users.
    #
    # https://community.frame.work/t/fedora-kde-becomes-suddenly-slow/58459
    # https://gitlab.freedesktop.org/drm/amd/-/issues/3647
    "amdgpu.dcdebugmask=0x10"
  ];
}
