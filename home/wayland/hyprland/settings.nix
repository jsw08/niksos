{
  wayland.windowManager.hyprland.settings = {
    xwayland = {
      force_zero_scaling = true;
    };

    general = {
      gaps_in = 5;
      gaps_out = 5;
      border_size = 1;

      resize_on_border = true;
    };

    decoration = {
      rounding = 10;
      rounding_power = 3;
      blur = {
        enabled = true;
        brightness = 1.0;
        contrast = 1.0;
        noise = 0.01;

        vibrancy = 0.2;
        vibrancy_darkness = 0.5;

        passes = 4;
        size = 7;

        popups = true;
        popups_ignorealpha = 0.2;
      };

      shadow = {
        enabled = true;
        ignore_window = true;
        offset = "0 15";
        range = 100;
        render_power = 2;
        scale = 0.97;
      };
    };

    animations = {
      enabled = true;
      animation = [
        "border, 1, 2, default"
        "fade, 1, 4, default"
        "windows, 1, 3, default, popin 80%"
        "workspaces, 1, 2, default, slide"
      ];
    };

    group = {
      groupbar = {
        font_size = 10;
        gradients = false;
      };
    };

    input = {
      repeat_rate = 60;
      repeat_delay = 200;
      kb_layout = "us";
      follow_mouse = 1;
      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      kb_options = "compose:ralt";

      touchpad = {
        natural_scroll = false;
      };
    };

    gestures = {
      workspace_swipe = true;
      workspace_swipe_forever = true;
      workspace_swipe_direction_lock = false;
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    misc = {
      disable_autoreload = true;
      force_default_wallpaper = 0;
      animate_mouse_windowdragging = false;
      vrr = 1;
    };

    windowrule = [
      "float, class:com.github.phase1geo.annotator"
      "float, class:foot-somcli"
      "size >30% >30%, class:foot-somcli"
    ];
    #NOTE: Also check home/wayland/hyprland/binds + system/hardware/fingerprint
  };
}
