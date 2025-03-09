{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  home.packages = lib.mkIf osConfig.niksos.desktop [
    pkgs.spotify
    pkgs.signal-desktop
  ];
}
