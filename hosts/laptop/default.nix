{
  imports = [
    ./hardware-configuration.nix
    ./virt.nix
  ];

  virtualisation.docker.enable = true;

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
