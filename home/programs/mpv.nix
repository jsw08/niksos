{
  pkgs,
  osConfig,
  ...
}: {
  programs.mpv = {
    enable = true;
    config = {
      vo = "gpu";
      profile = "gpu-hq";
      hwdec = "auto-safe";
      gpu-context = "wayland";
      ytdl-format = "bestvideo[height<=?1440]+bestaudio/best";
      volume-max = 200;
      fs = true;
      save-position-on-quit = true;
      webui-port = 9090;
    };

    scripts = with pkgs.mpvScripts; [
      uosc
      youtube-upnext
      thumbfast
      sponsorblock
      mpv-cheatsheet
      simple-mpv-webui
    ];
  };
}
