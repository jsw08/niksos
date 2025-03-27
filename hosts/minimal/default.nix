{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.plymouth.enable = false;
  services.fwupd.enable = false;

  # Other stuff that's enabled by default because i'll use it but it's still bloat is (note that this list shares a lot of resources):
  # - graphics drivers (~1.8gb)
  # - networkmanager (~1.25gb)
  # - polkit (~1.25gb)
  # - other stuff.. total: 4.68gb
}
