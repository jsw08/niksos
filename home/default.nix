{osConfig, ...}: {
  imports = [
    ./wayland
    ./shell
    ./style
    ./programs
  ];

  home = {
    inherit (osConfig.system) stateVersion;
    username = "jsw";
  };

  programs.home-manager.enable = true;
}
