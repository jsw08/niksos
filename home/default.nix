{
  osConfig,
  inputs,
  ...
}: {
  imports = [
    inputs.stylix.homeManagerModules.stylix
    inputs.nixcord.homeModules.nixcord

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
