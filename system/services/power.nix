{
  services = {
    logind = {
      powerKey = "suspend-then-hibernate";
      powerKeyLongPress = "poweroff";
    };
    upower.enable = true;
    power-profiles-daemon.enable = true;
  };
}
