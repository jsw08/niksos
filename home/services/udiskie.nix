{osConfig, ...}: {
  services.udiskie = {
    enable = osConfig.niksos.desktop;
    tray = "never"; #NOTE: Don't have a bar (yet?)
  };
}
