{
  config,
  lib,
  ...
}: {
  options.niksos.portable = lib.mkEnableOption "battery optimisers";
  config.services = lib.mkIf config.niksos.portable {
    logind = {
      powerKey = "suspend-then-hibernate";
      powerKeyLongPress = "poweroff";
    };
    upower.enable = true;
    power-profiles-daemon.enable = true;
  };
}
