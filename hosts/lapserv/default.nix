{
  imports = [
    ./hardware-configuration.nix
  ];

  niksos = {
    server = true;
    graphics.nvidia = false; #FIXME: Compile error
    graphics.intel = true;
  };

  services.immich = {
    # settings.ffmepg.accel =  "nvenc";
    settings.ffmpeg.preferredHwDevice = "/dev/dri/renderD128";
    accelerationDevices = [
      "/dev/dri/renderD128"
    ];
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';
}
