{pkgs, ...}: {
  imports = [
    ./fuzzel.nix
    ./hyprland
    ./hyprlock.nix
    ./mako.nix
  ];

  home.packages = [
    pkgs.wl-clipboard
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };
}
