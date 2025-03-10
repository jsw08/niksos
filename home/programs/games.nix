{
  pkgs,
  osConfig,
  lib,
  ...
}: {
  # Also look at system/programs/games.nix (some programs have to be overlayed or have systemwide modules that have to be installed.)
  home.packages = lib.mkIf osConfig.niksos.games [
    pkgs.dolphin-emu
    pkgs.suyu
  ];
}
