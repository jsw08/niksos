{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.niksos.hardware.printer {
    services.printing = {
      enable = true;
      startWhenNeeded = true;
    };
    hardware.printers = {
      ensureDefaultPrinter = "Broeder";
      ensurePrinters = [
        {
          deviceUri = "ipp://192.168.1.33/ipp";
          location = "home";
          name = "Broeder";
          model = "everywhere";
        }
      ];
    };
  };
}
