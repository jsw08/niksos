{
  inputs,
  specialArgs,
  lib,
  config,
  ...
}: let
  cfg = config.niksos.desktop.enable;
in {
  home-manager = lib.mkIf cfg {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = specialArgs;
    backupFileExtension = "backup";

    users.jsw = import ../../home;
  };

  programs.dconf.enable = cfg; # else gtk-managed stuff won't work
}
