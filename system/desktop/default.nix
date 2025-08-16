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
    ./comma.nix
    ./greetd.nix
    ./hyprland.nix
    ./pipewire.nix
    ./plasma6.nix
    ./polkit.nix
    ./xdg.nix
  ];

  options.niksos.desktop = {
    enable = mkEO "enable desktop related programs (+home manager).";
    apps = mkEO "extra bloat.";
    games = mkEO "gaming related programs";

    hyprland = mkEO "enable hyprland related programs.";
    kde = mkEO "enable kde specialisation.";
    activeDesktop = lib.mkOption {
      type = lib.types.enum ["hyprland" "kde"];
      description = "What desktop should be the default, other enabled desktops will be specialized.";
      default =
        if cfg.hyprland
        then "hyprland"
        else if cfg.kde
        then "kde"
        else "hyprland";
      example = "hyprland";
    };
  };

  config.assertions = mkIf (cfg.hyprland
    || cfg.kde) [
    {
      assertion = cfg.enable;
      message = "You need to enable desktop for the hyprland/kde module to work";
    }
    {
      assertion = config.niksos.desktop.enable;
      message = "The games option needs desktop to be enabled for it to work properly (it enables home-manager).";
    }
  ];
}
