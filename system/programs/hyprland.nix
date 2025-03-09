{
  config,
  pkgs,
  lib,
  ...
}: {
  options.niksos.desktop = lib.mkEnableOption "desktop related stuff.";
  config = lib.mkIf config.niksos.desktop {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
    environment.systemPackages = [
      #FIXME: migrated to home-manager
      pkgs.kitty # This is the default config's terminal and also my main one.
    ];
    environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Makes electron apps use wayland.
  };
}
