{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.niksos.desktop.enable && config.niksos.desktop.kde;
in {
  specialisation.de.configuration = lib.mkIf cfg {
    niksos.desktop.hyprland = lib.mkForce false;
    services = {
      greetd = let
        session.command = "${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland";
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
    programs.uwsm.enable = false;

    home-manager.users.jsw.stylix.autoEnable = false;
  };
}
