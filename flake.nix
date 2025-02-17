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
    flake-parts.url = "github:hercules-ci/flake-parts";

    hm = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Ricing
    stylix.url = "github:danth/stylix";

    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
