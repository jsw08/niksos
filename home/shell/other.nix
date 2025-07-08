{
  pkgs,
  lib,
  osConfig,
  inputs,
  ...
}: let
  inherit (lib) optionals;
  inherit (osConfig.niksos.hardware) bluetooth portable;
in {
  home.packages =
    [
      pkgs.ripgrep
      pkgs.p7zip
      pkgs.dua
      pkgs.ffmpeg

      pkgs.usbutils
      pkgs.pciutils
      pkgs.inetutils
      pkgs.aria2
      pkgs.file
    ]
    ++ optionals bluetooth [
      pkgs.ear2ctl
    ]
    ++ optionals portable.enable [
      inputs.somcli.defaultPackage.${pkgs.system}
    ];
}
