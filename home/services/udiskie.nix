{osConfig, ...}: {
  services.udiskie = {
    inherit (osConfig.services.udisks2) enable;
    tray = "never"; #NOTE: Don't have a bar (yet?)
  };
}
