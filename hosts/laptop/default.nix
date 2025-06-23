{
  imports = [
    ./hardware-configuration.nix
    ./virt.nix
  ];

  # services.printing = {
  #   enable = true;
  #   startWhenNeeded = true;
  # };
  # hardware.printers = {
  #   ensureDefaultPrinter = "Broeder";
  #   ensurePrinters = [
  #     {
  #       deviceUri = "ipp://192.168.1.33/ipp";
  #       location = "home";
  #       name = "Broeder";
  #       model = "everywhere";
  #     }
  #   ];
  # };

  programs.evolution.enable = true; # FIXME: move to appropiate place.
  niksos = {
    fingerprint = true;
    bluetooth = true;
    portable = {
      enable = true;
      hyprland = {
        powerSaver = ''
          hyprctl keyword monitor eDP-1,2880x1920@60,0x0,1.5,vrr,1
        '';
        performance = ''
          hyprctl keyword monitor eDP-1,2880x1920@120,0x0,1.5,vrr,1
        '';
      };
    };

    neovim = true;
    games = true;
    desktop = {
      enable = true;
      hyprland = true;
      kde = true;
    };
  };
  home-manager.users.jsw = {
    wayland.windowManager.hyprland.settings.monitor = ["eDP-1,2880x1920@120,0x0,1.5,vrr,1"];
    services.wluma = {
      enable = true;
      settings = {
        als.iio = {
          path = "/sys/bus/iio/devices";
          thresholds = {
            "0" = "night";
            "10" = "dark";
            "100" = "normal";
            "20" = "dim";
            "200" = "bright";
            "500" = "outdoors";
          };
        };
        output.backlight = [
          {
            capturer = "none";
            name = "eDP-1";
            path = "/sys/class/backlight/amdgpu_bl1";
          }
          {
            capturer = "none";
            name = "keyboard";
            path = "/sys/bus/platform/devices/cros-keyboard-leds.5.auto/leds/chromeos::kbd_backlight";
          }
        ];
      };
    };
  };
  hardware.sensor.iio.enable = true; # brightness sensor

  services = {
    usbmuxd.enable = true;
    joycond.enable = true;

    udev.extraRules = ''
      # Ethernet expansion card support
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/autosuspend}="20"
    '';
  };

  boot.kernelParams = [
    # There seems to be an issue with panel self-refresh (PSR) that
    # causes hangs for users.
    #
    # https://community.frame.work/t/fedora-kde-becomes-suddenly-slow/58459
    # https://gitlab.freedesktop.org/drm/amd/-/issues/3647
    "amdgpu.dcdebugmask=0x10"
  ];
}
