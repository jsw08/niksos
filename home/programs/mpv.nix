{
  pkgs,
  osConfig,
  ...
}: {
  programs.mpv = {
    enable = osConfig.niksos.desktop;
    config = {
      vo = "gpu";
      profile = "gpu-hq";
      hwdec = "auto-safe";
      gpu-context = "wayland";
      ytdl-format = "bestvideo+bestaudio";
      volume-max = 200;
      fs = true;
      save-position-on-quit = true;
    };

    scripts = with pkgs.mpvScripts; [
      uosc
      youtube-upnext
      thumbfast
      sponsorblock
      mpv-cheatsheet
    ];
  };
}
