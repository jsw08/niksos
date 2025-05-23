{
  config,
  lib,
  ...
}: let
  mkEO = lib.mkEnableOption;
  cfg = config.niksos.desktop;

  inherit (lib) mkIf optional;
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

  config.assertions = mkIf (cfg.hyprland
    || cfg.kde) [
    {
      assertion = cfg.enable;
      message = "You need to enable desktop for the hyprland/kde module to work";
    }
  ];
}
