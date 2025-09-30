{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.interfaces.enp2s0.wakeOnLan.enable = true;

  niksos = {
    # server = true;
    server = {
      baseDomain = "jsw.tf";
      derek-bot.enable = true;
      derek-site.enable = true;
      forgejo = {
        enable = true;
        subDomain = "git";
      };
      immich = {
        enable = true;
        subDomain = "photos";
      };
      jsw-bot = {
        enable = true;
        subDomain = "dc";
      };
      nextcloud = {
        enable = true;
        subDomain = "cloud";
      };
      stalwart = {
        enable = true;
        subDomain = "mail";
      };
      zitadel = {
        enable = true;
        subDomain = "z";
      };
      site = {
        enable = true;
        subDomain = "";
      };
    };
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
  services.logind.settings.Login.lidSwitchExternalPower = "ignore"; # INFO: Above apparantly wasn't enough. logind is flooding my logs.
}
