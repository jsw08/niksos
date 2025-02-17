{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: let
  inherit (config.lib.stylix) colors;

  waybar_config = import ./config.nix {inherit osConfig config lib pkgs;};
  waybar_style_content = import ./style.nix {inherit colors;};
  waybar_style = pkgs.writeText "waybar-style.css" waybar_style_content;
in {
  home.packages = with pkgs.python3Packages; [requests];
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    package = pkgs.waybar;
    settings = waybar_config;
    # style = waybar_style;
  };
}
