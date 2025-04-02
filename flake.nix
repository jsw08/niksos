{
  description = "Nix is here, nix is everywhere, nix is everything.";

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        ./hosts
      ];

      perSystem = {
        config,
        pkgs,
        ...
      }: {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.alejandra
            pkgs.git
          ];
          name = "dots";
          DIRENV_LOG_FORMAT = "";
        };

        formatter = pkgs.alejandra;
      };
    };

  inputs = {
    # Nixpkgs and other core shit
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small"; # build error unrelated to config.
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11-small"; # build error unrelated to config.
    flake-parts.url = "github:hercules-ci/flake-parts";

    hm = {
      url = "github:nix-community/home-manager/master";
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
    dcbot = {
      url = "github:jsw08/dcbot";
      flake = false;
    };

    agenix.url = "github:ryantm/agenix";
  };
}
