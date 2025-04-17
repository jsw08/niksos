{
  hardware.enableRedistributableFirmware = true;

  imports = [
    ./bluetooth.nix
    ./graphics.nix
    ./fingerprint.nix
    ./fwupd.nix
  ];
}
