{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.interfaces.enp2s0.wakeOnLan.enable = true;

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
  services.logind.lidSwitchExternalPower = "ignore"; # INFO: Above apparantly wasn't enough. logind is flooding my logs.
}
