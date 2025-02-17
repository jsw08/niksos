{pkgs, ...}: {
  imports = [
    ./fuzzel.nix
    ./hyprlock.nix
    ./hyprland
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
