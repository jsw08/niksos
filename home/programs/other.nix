{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  home.packages = [
    pkgs.spotify
    pkgs.signal-desktop
  ];
}
