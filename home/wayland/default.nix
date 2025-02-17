{pkgs, ...}: {
  imports = [
    ./fuzzel.nix
    ./hyprlock.nix
    ./hyprland
    ./waybar
  ];

  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    wlr-randr
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };
}
