{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;

  #TODO: UWSM library mentioned in binds.nix.
  hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
  fuzzel = getExe pkgs.fuzzel;
  kitty = getExe pkgs.kitty;

  pulsemixer = "${kitty} ${getExe pkgs.pulsemixer}";
  nmtui = "${kitty} ${pkgs.networkmanager}/bin/nmtui";
in {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "bottom";
        position = "bottom";
        mod = "dock";
        exclusive = true;
        gtk-layer-shell = true;
        margin-bottom = -1;
        passthrough = false;
        height = 41;
        modules-left = [
          "custom/os_button"
          "hyprland/workspaces"
          "wlr/taskbar"
        ];
        modules-center = [
        ];
        modules-right = [
          "cpu"
          "memory"
          "disk"
          "tray"
          "pulseaudio"
          "network"
          "battery"
          "clock"
        ];
        "hyprland/language" = {
          format = "{}";
          format-en = "ENG";
          format-ru = "РУС";
        };
        "hyprland/workspaces" = {
          icon-size = 32;
          spacing = 14;
          align = "center";
          justify = "center";
          on-scroll-up = "${hyprctl} dispatch workspace r+1";
          on-scroll-down = "${hyprctl} dispatch workspace r-1";
        };
        "custom/os_button" = {
          format = "";
          on-click = fuzzel;
          tooltip = false;
        };
        cpu = {
          interval = 5;
          format = "  {usage}%";
          max-length = 10;
        };
        disk = {
          interval = 30;
          format = "󰋊 {percentage_used}%";
          path = "/";
          tooltip = true;
          unit = "GB";
          tooltip-format = "Available {free} of {total}";
        };
        memory = {
          interval = 10;
          format = "  {percentage}%";
          max-length = 10;
          tooltip = true;
          tooltip-format = "RAM - {used:0.1f}GiB used";
        };
        "wlr/taskbar" = {
          format = "{icon} {title:.17}";
          icon-size = 28;
          spacing = 3;
          on-click-middle = "close";
          tooltip-format = "{title}";
          ignore-list = [
          ];
          on-click = "activate";
        };
        tray = {
          icon-size = 18;
          spacing = 3;
        };
        clock = {
          format = "      {:%R\n %d.%m.%Y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };
        network = {
          format-wifi = " {icon}";
          format-ethernet = " ";
          format-disconnected = "󰌙";
          format-icons = [
            "󰤯 "
            "󰤟 "
            "󰤢 "
            "󰤢 "
            "󰤨 "
          ];
          on-click = nmtui;
        };
        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };
        pulseaudio = {
          max-volume = 150;
          scroll-step = 10;
          format = "{icon}";
          tooltip-format = "{volume}%";
          format-muted = " ";
          format-icons = {
            default = [
              " "
              " "
              " "
            ];
          };
          on-click = pulsemixer;
        };
      };
    };
    style = ''
      * {
      	text-shadow: none;
      	box-shadow: none;
        border: none;
        border-radius: 0;
        font-family: "DejaVuSansM Nerd Font:style=Regular";
        font-weight: 600;
        font-size: 12.7px;
      }

      window#waybar {
        background:  @base00;
        border-top: 1px solid @base01;
        color: @base05;
      }

      tooltip {
        background: @base01;
        border-radius: 5px;
        border-width: 1px;
        border-style: solid;
        border-color: @base01;
      }
      tooltip label{
        color: @base05;
      }

      #custom-os_button {
        font-size: 24px;
      	padding-left: 12px;
      	padding-right: 20px;
      	transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }
      #custom-os_button:hover {
        background:  @base03;
      	color: @base05;
      }

      #workspaces {
        color: transparent;
      	margin-right: 1.5px;
      	margin-left: 1.5px;
      }
      #workspaces button {
        padding: 3px;
        color: @base04;
      	transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }
      #workspaces button.active {
      	color: @base05;
      	border-bottom: 3px solid white;
      }
      #workspaces button.focused {
        color: @base02;
      }
      #workspaces button.urgent {
      	background:  rgba(255, 200, 0, 0.35);
      	border-bottom: 3px dashed @warning_color;
      	color: @warning_color;
      }
      #workspaces button:hover {
        background: @base03;
      	color: @base05;
      }


      #taskbar button {
      	min-width: 130px;
      	border-bottom: 3px solid rgba(255, 255, 255, 0.3);
      	margin-left: 2px;
      	margin-right: 2px;
        padding-left: 8px;
        padding-right: 8px;
        color: white;
      	transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }

      #taskbar button.active {
      	border-bottom: 3px solid white;
        background: @base02;
      }

      #taskbar button:hover {
      	border-bottom: 3px solid white;
        background: @base03;
      	color: @base05;
      }

      #cpu, #disk, #memory {
      	padding:3px;
      }


      #window {
        border-radius: 10px;
        margin-left: 20px;
        margin-right: 20px;
      }

      #tray{
        margin-left: 5px;
        margin-right: 5px;
      }
      #tray > .passive {
      	border-bottom: none;
      }
      #tray > .active {
      	border-bottom: 3px solid white;
      }
      #tray > .needs-attention {
      	border-bottom: 3px solid @warning_color;
      }
      #tray > widget {
      	transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }
      #tray > widget:hover {
      	background: @base03;
      }

      #pulseaudio {
      	font-family: "JetBrainsMono Nerd Font";
      	padding-left: 3px;
        padding-right: 3px;
      	transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }
      #pulseaudio:hover {
       	background: @base03;
      }

      #network {
      	padding-left: 3px;
        padding-right: 3px;
      }

      #language {
        padding-left: 5px;
        padding-right: 5px;
      }

      #clock {
        padding-right: 5px;
        padding-left: 5px;
      	transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }
      #clock:hover {
      	background: @base03;
      }
    '';
  };
}
