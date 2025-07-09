{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (config.niksos) desktop;
  cfg = desktop.enable && desktop.kde;
  active = cfg && desktop.activeDesktop == "kde";
  ifActive = x: lib.mkIf active x;
in {
  specialisation.kde.configuration =
    lib.mkIf cfg
    && !active {
      niksos.desktop.activeDesktop = lib.mkForce "kde";
    };

  services = ifActive {
    greetd.settings = let
      session.command = "${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland";
    in {
      default_session = session;
      initial_session = session;
    };

    desktopManager.plasma6.enable = true;
  };
  home-manager.users = ifActive {
    jsw.stylix.autoEnable = false;
  };
}
