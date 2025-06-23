{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config) niksos;
  cfg = niksos.portable;
in {
  options.niksos.portable = {
    enable = lib.mkEnableOption "battery optimisers";
    hyprland = let
      gen = mode:
        lib.mkOption {
          default = "";
          description = "Shell commands to run when switching to ${mode} mode.";
          type = lib.types.lines;
        };
    in {
      powerSaver = gen "power-saver";
      performance = gen "performance";
    };
  };
  config = {
    services = lib.mkIf cfg.enable {
      logind = {
        powerKey = "suspend-then-hibernate";
        powerKeyLongPress = "poweroff";
      };
      upower.enable = true;
      power-profiles-daemon.enable = true;
    };

    environment.systemPackages = lib.mkIf niksos.desktop.hyprland [
      (pkgs.writeScriptBin "powermode" ''
        #!/usr/bin/env bash

        function sync() {
          if [ "$(powerprofilesctl get)" = "power-saver" ]; then
            hyprctl --batch "\
                keyword animations:enabled 0;\
                keyword decoration:shadow:enabled 0;\
                keyword decoration:blur:enabled 0;\
                keyword general:gaps_in 0;\
                keyword general:gaps_out 0;\
                keyword general:border_size 1;\
                keyword decoration:rounding 0"

            ${cfg.hyprland.powerSaver}
          else
            ${cfg.hyprland.performance}
            hyprctl reload
          fi

        }
        function toggle() {
          if [ "$(powerprofilesctl get)" = "power-saver" ]; then
            powerprofilesctl set performance
          else
            powerprofilesctl set power-saver
          fi

          sync
        }

        if [ "$#" -ne 1 ]; then
          echo "Usage: $0 {toggle|sync}"
          exit 1
        fi

        case "$1" in
        toggle)
          toggle
          ;;
        sync)
          sync
          ;;
        *)
          echo "Invalid option: $1"
          echo "Usage: $0 {toggle|sync}"
          exit 1
          ;;
        esac
      '')
    ];
  };
}
