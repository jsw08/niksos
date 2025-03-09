{
  lib,
  config,
  pkgs,
  ...
}: {
  options.niksos.bluetooth = lib.mkEnableOption "bluetooth related stuff.";

  config = lib.mkIf config.niksos.bluetooth {
    hardware.bluetooth = {
      enable = true;
      input.General.ClassicBondedOnly = false;
    };
    environment.systemPackages = [pkgs.bluetui];
  };
}
