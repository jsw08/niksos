{lib, ...}: let
  mkEO = lib.mkEnableOption;
in {
  config.hardware.enableRedistributableFirmware = true;

  imports = [
    ./bluetooth.nix
    ./fingerprint.nix
    ./fwupd.nix
    ./graphics.nix
    ./joycond.nix
    ./power.nix
  ];

  options.niksos.hardware = {
    bluetooth = mkEO "bluetooth related stuff.";
    fingerprint = mkEO "fingerprint support.";

    graphics = {
      enable = mkEO "core graphics";
      intel = mkEO "additional intel drivers";
      nvidia = mkEO "additoinal nvidia drivers";
    };

    joycond = mkEO "support for nintendo switch controllers.";

    portable = {
      enable = mkEO "battery optimisers";
      hyprland = let
        gen = mode:
          lib.mkOption {
            default = "";
            description = "Shell commands to run when switching to ${mode} mode.";
            type = lib.types.lines;
          };
      in {
        powerSaver = gen "power-saver";
        performance = gen "performance";
      };
    };
  };
}
