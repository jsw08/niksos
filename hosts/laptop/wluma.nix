{
  hardware.sensor.iio.enable = true; # brightness sensor
  home-manager.users.jsw.services.wluma = {
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
}
