{
  imports = [
    ./hardware-configuration.nix
  ];

  niksos = {
    hardware = {
      bluetooth = true;
      printer = true;
    };

    neovim = true;
    desktop = {
      games = true;
      apps = true;
      enable = true;
      hyprland = true; #TODO: flip both, just trying if it works.
      kde = true;
      activeDesktop = "hyprland";
    };
  };
  home-manager.users.jsw.wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-3,2560x1440@165,0x0,1,vrr,1"
      "HDMI-A-1,1920x1080,2560x540,1"
    ];
    workspace = [
      "1, monitor:DP-3"
      "2, monitor:DP-3"
      "3, monitor:DP-3"
      "4, monitor:HDMI-A-1"
      "5, monitor:HDMI-A-1"
      "6, monitor:DP-3"
      "7, monitor:DP-3"
      "8, monitor:DP-3"
      "9, monitor:DP-3"
      "0, monitor:HDMI-A-1"
    ];
  };
}
