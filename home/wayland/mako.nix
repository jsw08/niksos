{osConfig, ...}: {
  services.mako = {
    enable = osConfig.niksos.desktop;
    defaultTimeout = 5000;
  };
}
