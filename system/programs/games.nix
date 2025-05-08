{
  config,
  pkgs,
  lib,
  ...
}: {
  options.niksos.games = lib.mkEnableOption "gaming related stuff.";
  config = lib.mkIf config.niksos.games {
    # nixpkgs.overlays = [
    #   (final: prev: let
    #     version = "1.4.2";
    #     hash = "sha256-xe0qlbtt06CUK8bXyaGDtCcHOXpSnkbuvcxaDJjeS/c=";
    #     npmHash = "sha256-/+NhlQydGS6+2jEjpbwycwKplVo/++wcdPiBNY3R3FI=";
    #     cargoHash = "sha256-VwzGbm34t7mg9ndmTkht6Ho32NQ+6uxuPTKi3+VrhYo=";
    #   in {
    #     gale = prev.gale.overrideAttrs (new: old: {
    #       src = prev.fetchFromGitHub {
    #         inherit version hash;
    #         owner = "Kesomannen";
    #         repo = "gale";
    #         rev = "1.4.2";
    #       };
    #       npmDeps = prev.fetchNpmDeps {
    #         hash = npmHash;
    #         name = "${new.pname}-${new.version}-npm-deps";
    #         inherit (new) src;
    #       };
    #       cargoDeps = prev.rustPlatform.fetchCargoVendor {
    #         inherit
    #           (new)
    #           pname
    #           version
    #           src
    #           cargoRoot
    #           ;
    #         hash = cargoHash;
    #       };
    #     });
    #   })
    # ];
    users.users.jsw.packages = [pkgs.gale];

    programs = {
      gamescope = {
        enable = true;
        capSysNice = true;
        args = [
          "--rt"
          "--expose-wayland"
        ];
      };

      steam = {
        enable = true;

        extraCompatPackages = [
          pkgs.proton-ge-bin
        ];

        gamescopeSession.enable = true;
      };
    };
    environment.variables = {
      "STEAM_FORCE_DESKTOP_UI_SCALING" = "1.5"; #FIXME:.
    };
  };
}
