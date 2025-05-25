{
  osConfig,
  inputs,
  ...
}: {
  imports = [
    inputs.stylix.homeModules.stylix
    inputs.nixcord.homeModules.nixcord
    inputs.nvf.homeManagerModules.default

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
