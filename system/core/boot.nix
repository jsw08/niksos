{
  pkgs,
  config,
  lib,
  ...
}: let
  plymouth = config.boot.plymouth.enable;
in {
  boot = {
    bootspec.enable = true;

    initrd = {
      systemd.enable = true;
      supportedFilesystems = ["ext4"];
    };

    # use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;

    consoleLogLevel = 3;
    kernelParams = lib.mkIf plymouth [
      "quiet"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
      "plymouth.use-simpledrm"
    ];

    loader = {
      # systemd-boot on UEFI
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        netbootxyz.enable = true;
      };

      timeout = 0;
    };

    plymouth.enable = lib.mkDefault true;
  };
}
