{
  hardware.enableRedistributableFirmware = true;

  imports = [
    ./bluetooth.nix
    ./commonGraphics.nix
    ./fingerprint.nix
    ./fwupd.nix
  ];
}
