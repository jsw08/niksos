{
  pkgs,
  lib,
  osConfig,
  inputs,
  ...
}: let
  inherit (lib) optionals;
  inherit (osConfig.niksos.hardware) bluetooth portable;
  inherit (osConfig.niksos.desktop) apps;
in {
  home.packages =
    [
      pkgs.ripgrep
      pkgs.fzf

      pkgs.p7zip
      pkgs.dua

      pkgs.usbutils
      pkgs.pciutils
      pkgs.inetutils
      pkgs.aria2
      pkgs.file
    ]
    ++ optionals apps [
      # Kinda don't need to include these on more minimal installs.
      pkgs.ffmpeg
      pkgs.imagemagick
      pkgs.ghostscript
    ]
    ++ optionals bluetooth [
      pkgs.ear2ctl
    ]
    ++ optionals portable.enable [
      inputs.somcli.defaultPackage.${pkgs.system}
    ];
}
