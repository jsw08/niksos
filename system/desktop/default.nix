{lib, ...}: let
  mkEO = lib.mkEnableOption;
in {
  imports = [
    ./greetd.nix
    ./hyprland.nix
    ./pipewire.nix
    ./plasma6.nix
    ./polkit.nix
    ./xdg.nix
  ];

  options.niksos.desktop = {
    enable = mkEO "enable desktop related programs.";
    hyprland = mkEO "enable hyprland related programs.";
    kde = mkEO "enable kde specialisation.";
  };
}
