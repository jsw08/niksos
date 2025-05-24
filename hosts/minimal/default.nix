{
  #NOTE: This config serves as a list of all of the available options

  imports = [
    ./hardware-configuration.nix
  ];

  boot.plymouth.enable = false;
  services.fwupd.enable = false;

  niksos = {
    bluetooth = false;
    desktop = {
      enable = false;
      hyprland = false;
      kde = false;
    };
    fingerprint = false;
    games = false;
    graphics = {
      enable = false;
      intel = false;
      nvidia = false;
    };
    neovim = false;
    portable = false;
    server = false;
  };

  #NOTE: Old info
  ## Other stuff that's enabled by default because i'll use it but it's still bloat is (note that this list shares a lot of resources):
  ## - graphics drivers (~1.8gb)
  ## - networkmanager (~1.25gb)
  ## - polkit (~1.25gb)
  ## - other stuff.. total: 4.68gb
}
