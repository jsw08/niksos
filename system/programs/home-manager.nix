{inputs, specialArgs, config, ...}: {
  imports = [
    inputs.hm.nixosModules.default
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = specialArgs;

    users.jsw = import ../../home;
  };

  programs.dconf.enable = true; # else gtk-managed stuff won't work
}
