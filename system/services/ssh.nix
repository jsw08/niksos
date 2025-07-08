{config, ...}: {
  services.openssh = {
    enable = true;
    openFirewall = !config.niksos.hardware.portable.enable;
    settings.UseDns = true;
  };
}
