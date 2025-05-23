{osConfig, ...}: {
  services.mako = {
    enable = osConfig.niksos.desktop.hyprland;
    settings.defaultTimeout = 5000;
  };
}
