{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (config.niksos) desktop;
  cfg = desktop.enable && desktop.hyprland;
  active = cfg && desktop.activeDesktop == "hyprland";
  ifActive = x: lib.mkIf active x;
in {
  specialisation.hyprland.configuration = lib.mkIf (cfg
    && !active) {
    niksos.desktop.activeDesktop = lib.mkForce "hyprland";
  };

  programs = ifActive {
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    uwsm.enable = true;
  };

  services.greetd.settings = let
    session = {
      command = "${lib.getExe config.programs.uwsm.package} start hyprland-uwsm.desktop";
      user = "jsw";
    };
  in
    ifActive {
      default_session = session;
      initial_session = session;
    };
  environment.sessionVariables.NIXOS_OZONE_WL = ifActive "1"; # Makes electron apps use wayland.
}
