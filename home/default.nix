{osConfig, ...}: {
  imports = [
    ./wayland
    ./shell
    ./style
    ./programs
    ./services
  ];

  home = {
    inherit (osConfig.system) stateVersion;
    username = "jsw";
  };

  programs.home-manager.enable = true;
}
