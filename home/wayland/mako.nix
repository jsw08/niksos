{osConfig, ...}: let
  inherit (osConfig.niksos) desktop;
in {
  services.mako = {
    inherit (osConfig.programs.hyprland) enable;
    settings.default_timeout = 5000;
  };
}
