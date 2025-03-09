{pkgs, ...}: {
  home.packages = [
    pkgs.gh
    pkgs.ripgrep

    pkgs.ear2ctl # FIXME: only when bluetooth enabled
    pkgs.bluetui

    pkgs.typst #FIXME:  move to flake shell
  ];
}
