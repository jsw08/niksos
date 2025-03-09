{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig.niksos) desktop;
in {
  imports = [
    ./fuzzel.nix
    ./hyprland
    ./hyprlock.nix
    ./mako.nix
  ];

  home.packages = mkIf desktop [
    pkgs.wl-clipboard
  ];

  home.sessionVariables = mkIf desktop {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };
}
