{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.niksos.desktop.enable && config.niksos.desktop.kde;
in {
  config = lib.mkIf cfg {
    niksos.desktop.hyprland = lib.mkForce false;
    specialisation.de.configuration = {
      services = {
        greetd = let
          session = {
            command = "${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland";
            user = "jsw";
          };
        in {
          enable = true;
          settings = {
            terminal.vt = 1;
            default_session = session;
            initial_session = session;
          };
        };

        desktopManager.plasma6.enable = true;
      };

      home-manager.users.jsw.stylix.autoEnable = false;
    };
  };
}
