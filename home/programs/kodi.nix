{pkgs, ...}: {
  home.packages = [
    (pkgs.kodi-wayland.withPackages (exts: [exts.inputstream-adaptive exts.inputstreamhelper]))
  ];
}
