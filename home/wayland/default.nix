{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  cfg = osConfig.niksos.desktop.hyprland;
in {
  imports = [
    ./fuzzel.nix
    ./hyprland
    ./hyprlock.nix
    ./mako.nix
  ];

  home.packages = mkIf cfg [
    pkgs.wl-clipboard
  ];

  home.sessionVariables = mkIf cfg {
    #FIXME: migrate to hyprconf
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };
}
