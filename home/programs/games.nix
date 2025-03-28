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

    # (
    #   pkgs.appimageTools.wrapType1 rec {
    #     pname = "nx-optimizer";
    #     version = "3.0.1";
    #
    #     src = pkgs.fetchurl {
    #       url = "https://github.com/MaxLastBreath/TOTK-mods/releases/download/manager-3.0.1/NX.Optimizer.3.0.1.AppImage";
    #       hash = "sha256-2InXpoLm4bfuj0FYRXruRxggBA/E6XiJFeuNbyAMk5s=";
    #     };
    #   }
    # )
  ];
}
