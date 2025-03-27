{
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

  home-manager.users.jsw.wayland.windowManager.hyprland.settings.monitor = ["eDP-1,2880x1920@120,0x0,1.5,vrr,1"];
  services = {
    fprintd.enable = true;
    udev.extraRules = ''
      # Ethernet expansion card support
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/autosuspend}="20"
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
