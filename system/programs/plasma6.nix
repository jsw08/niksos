{
  lib,
  pkgs,
  config,
  ...
}: {
  options.niksos.kde = lib.mkEnableOption "a kde specialisation. Will enable desktop settings.";

  config.specialisation.de.configuration = lib.mkIf config.niksos.kde {
    niksos.desktop = lib.mkForce true;

    services = {
      greetd = let
        session = {
          command = "${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland";
          user = "jsw";
        };
      in {
        settings = lib.mkForce {
          terminal.vt = 1;
          default_session = session;
          initial_session = session;
        };
      };

      desktopManager.plasma6.enable = true;
    };

    home-manager.users.jsw = {
      stylix.autoEnable = false;
    };
  };
}
