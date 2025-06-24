{
  hardware.enableRedistributableFirmware = true;

  imports = [
    ./bluetooth.nix
    ./fingerprint.nix
    ./fwupd.nix
    ./graphics.nix
    ./joycond.nix
    ./power.nix
  ];
}
