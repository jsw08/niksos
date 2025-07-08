{
  pkgs,
  osConfig,
  lib,
  ...
}: {
  home.packages = lib.mkIf osConfig.niksos.desktop.apps [
    (pkgs.kodi-wayland.withPackages (exts: [exts.inputstream-adaptive exts.inputstreamhelper]))
  ];
}
