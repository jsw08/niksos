{
  config,
  lib,
  ...
}: {
  services = lib.mkIf config.niksos.hardware.joycond {
    usbmuxd.enable = true;
    joycond.enable = true;
  };
}
