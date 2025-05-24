{
  description = "Nix is here, nix is everywhere, nix is everything.";

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        inputs.git-hooks-nix.flakeModule
        ./hosts
      ];

      perSystem = {
        config,
        pkgs,
        ...
      }: {
        pre-commit.settings.hooks = {
          alejandra.enable = true;
          flake-checker.enable = true;
          nil.enable = true;
        };

        formatter = pkgs.alejandra;
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.alejandra
            pkgs.git
          ];
          name = "dots";
          DIRENV_LOG_FORMAT = "";

          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };
      };
    };

  inputs = {
    # Nixpkgs and other core shit
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # build error unrelated to config.
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11-small"; # build error unrelated to config.
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hm = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Ricing
    stylix.url = "github:danth/stylix";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord.url = "github:kaylorben/nixcord";
    somcli.url = "github:jsw08/somcli";
    guiders.url = "github:jsw08/guiders";

    # Non-flake
    dcbot = {
      url = "github:jsw08/dcbot";
      flake = false;
    };
  };
}
