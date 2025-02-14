{
  hardware.enableRedistributableFirmware = true;

  imports = [
    ./bluetooth.nix
    ./commonGraphics.nix
    ./fwupd.nix
  ];
}
