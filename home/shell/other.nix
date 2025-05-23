{
  pkgs,
  lib,
  osConfig,
  inputs,
  ...
}: {
  home.packages =
    [
      pkgs.gh
      pkgs.ripgrep
      pkgs.p7zip
      pkgs.usbutils
      pkgs.pciutils
      pkgs.inetutils
      pkgs.aria2
      pkgs.dua
      pkgs.file
      pkgs.ffmpeg
      pkgs.gurk-rs
      pkgs.playerctl
    ]
    ++ lib.optionals osConfig.niksos.bluetooth [
      pkgs.ear2ctl
    ]
    ++ lib.optionals osConfig.niksos.portable [
      inputs.somcli.defaultPackage.${pkgs.system}
    ];
    ;
}
