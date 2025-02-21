{
  inputs,
  specialArgs,
  ...
}: {
  imports = [
    inputs.hm.nixosModules.default
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = specialArgs;
    backupFileExtension = "backup";

    users.jsw = import ../../home;
  };

  programs.dconf.enable = true; # else gtk-managed stuff won't work
}
