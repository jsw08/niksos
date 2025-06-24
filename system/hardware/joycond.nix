{
  config,
  lib,
  ...
}: {
  options.niksos.joycond = lib.mkEnableOption "support for nintendo switch controllers.";

  config.services = lib.mkIf config.niksos.joycond {
    usbmuxd.enable = true;
    joycond.enable = true;
  };
}
