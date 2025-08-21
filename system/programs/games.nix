{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.niksos.desktop.games;
in {
  config = lib.mkIf cfg {
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

    programs = {
      gamemode = {
        enable = true;
        enableRenice = true;
        settings = {
          general = {
            reaper_freq = 5;
            softrealtime = "on";
            renice = 0;
          };

          # WARNING: GPU optimisations have the potential to damage hardware!
          gpu = {
            apply_gpu_optimisations = "accept-responsibility";
            gpu_device = 0;
            amd_performance_level = "high";
          };
          custom = {
            start = "${pkgs.libnotify}/bin/notify-send 'Game\'s on bitch.'";
            end = "${pkgs.libnotify}/bin/notify-send 'Stopped gaming? :('";
          };
        };
      };
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

        extraPackages = [
          pkgs.gamemode
        ];
        extraCompatPackages = [
          pkgs.proton-ge-bin
        ];

        extest.enable = true;
        gamescopeSession.enable = true;
      };
    };
    environment.variables = {
      "STEAM_FORCE_DESKTOP_UI_SCALING" = "1.5"; #FIXME:.
    };
  };
}
