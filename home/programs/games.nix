{
  pkgs,
  osConfig,
  inputs,
  lib,
  ...
}: let
  inherit (osConfig.niksos) desktop hardware;
  inherit (desktop) games;
  inherit (hardware) bluetooth;
in {
  # Also look at system/programs/games.nix (some programs have to be overlayed or have systemwide modules that have to be installed.)
  home.packages = lib.mkIf games ([
      pkgs.dolphin-emu
      inputs.nixpkgs-torzu.legacyPackages.${pkgs.system}.torzu
      pkgs.gale
      pkgs.adwsteamgtk

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
    ]
    ++ lib.optional bluetooth pkgs.dualsensectl);
}
