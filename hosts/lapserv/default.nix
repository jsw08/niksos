{
  imports = [
    ./hardware-configuration.nix
  ];

  niksos = {
    server = true;
    hardware.graphics = {
      nvidia = false; #FIXME: Compile error
      intel = true;
    };
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
