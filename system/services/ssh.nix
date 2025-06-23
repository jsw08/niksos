{config, ...}: {
  services.openssh = {
    enable = true;
    openFirewall = !config.niksos.portable.enable;
    settings.UseDns = true;
  };
}
