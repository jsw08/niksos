{osConfig, ...}: {
  services.mako = {
    enable = osConfig.niksos.desktop;
    settings.defaultTimeout = 5000;
  };
}
