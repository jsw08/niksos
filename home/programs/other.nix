{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  home.packages = lib.mkIf osConfig.niksos.desktop.apps [
    pkgs.spotify
    pkgs.signal-desktop
    pkgs.bambu-studio
    pkgs.gimp
    pkgs.inkscape
    pkgs.thunderbird
  ];
}
