{
  osConfig,
  config,
  ...
}: let
  inherit (config.lib.stylix.colors) base05;
in {
  programs.hyprlock = {
    enable = osConfig.niksos.desktop.hyprland;

    settings = {
      general = {
        disable_loading_bar = true;
        immediate_render = true;
        hide_cursor = false;
        no_fade_in = true;
      };
      auth."fingerprint:enabled" = true;

      label = [
        {
          monitor = "";
          text = "$TIME";
          font_size = 150;
          color = "rgb(${base05})";

          position = "0%, 33%";

          valign = "center";
          halign = "center";

          shadow_color = "rgba(0, 0, 0, 0.1)";
          shadow_size = 20;
          shadow_passes = 2;
          shadow_boost = 0.3;
        }
        {
          monitor = "";
          text = "cmd[update:3600000] date +'%a %b %d'";
          font_size = 20;
          color = "rgb(${base05})";

          position = "0%, 40%";

          valign = "center";
          halign = "center";

          shadow_color = "rgba(0, 0, 0, 0.1)";
          shadow_size = 20;
          shadow_passes = 2;
          shadow_boost = 0.3;
        }
      ];
    };
  };
}
