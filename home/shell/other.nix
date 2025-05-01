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
      pkgs.rsync
      pkgs.usbutils
      pkgs.pciutils
      pkgs.inetutils
      pkgs.aria2
      pkgs.dua
      pkgs.file
    ]
    ++ lib.optionals osConfig.niksos.desktop [
      inputs.somcli.defaultPackage.${pkgs.system}
      pkgs.ffmpeg
      pkgs.gurk-rs
    ]
    ++ lib.optionals osConfig.niksos.bluetooth [
      pkgs.ear2ctl
    ];
}
