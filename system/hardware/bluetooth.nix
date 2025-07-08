{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.niksos.hardware.bluetooth {
    hardware.bluetooth = {
      enable = true;
      input.General.ClassicBondedOnly = false;
    };
    environment.systemPackages = [pkgs.bluetui];
  };
}
