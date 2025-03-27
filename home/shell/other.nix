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
    ]
    ++ lib.optionals osConfig.niksos.desktop [
      inputs.somcli.defaultPackage.${pkgs.system}
    ]
    ++ lib.optionals osConfig.niksos.bluetooth [
      pkgs.ear2ctl
    ];
}
