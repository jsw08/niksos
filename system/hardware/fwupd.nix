{lib, ...}: {
  services.fwupd.enable = lib.mkDefault true; #NOTE: this enables udisks2
}
