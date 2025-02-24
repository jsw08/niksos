{pkgs, ...}: {
  home.packages = [
    pkgs.gh
    pkgs.ripgrep
    pkgs.ear2ctl # FIXME: only when bluetooth enabled
  ];
}
