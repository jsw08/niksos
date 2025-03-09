{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.niksos.desktop {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
    };

    environment.systemPackages = [pkgs.pulsemixer];
    services.pulseaudio.enable = lib.mkForce false; # gnome enables it
  };
}
