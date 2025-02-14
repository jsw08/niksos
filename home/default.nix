{osConfig, ...}: {
  imports = [
    ./wayland
    ./shell
    ./style
  ];

  home = {
    inherit (osConfig.system) stateVersion;
    username = "jsw";
  };

  programs.home-manager.enable = true;
}
