{
  self,
  inputs,
  lib,
  ...
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem genAttrs;

  specialArgs = {inherit inputs self;};
  modules = [
    inputs.hm.nixosModules.home-manager
    inputs.agenix.nixosModules.default
    inputs.nix-index-database.nixosModules.nix-index

    ../system
    ../secrets
  ];
in {
  flake = let
    systems = [
      "laptop"
      "lapserv"
      "minimal"
      "desktop"
    ];
  in {
    # Systems
    nixosConfigurations = genAttrs systems (hostName:
      nixosSystem {
        inherit specialArgs;
        modules =
          modules
          ++ [
            {
              imports = [./${hostName}];
              networking = {inherit hostName;};
            }
          ];
      });
  };

  perSystem = {
    # Allows running 'nix run github:jsw08/NixOS' and it'll spin up a vm.
    config,
    pkgs,
    ...
  }: let
    nixos-vm = nixosSystem {
      inherit specialArgs;
      modules =
        modules
        ++ [
          {
            boot.plymouth.enable = false;
            services.fwupd.enable = false;
            networking.hostName = "vm";

            niksos = {
              desktop = {
                enable = true;
                hyprland = true;
              };
              neovim = true;
            };

            nixpkgs.hostPlatform = pkgs.system;
          }
        ];
    };
  in {
    apps.default = {
      type = "app";
      program = "${nixos-vm.config.system.build.vm}/bin/run-vm-vm";
    };
  };
}
