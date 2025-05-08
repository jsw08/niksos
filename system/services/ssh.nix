{config, ...}: {
  services.openssh = {
    enable = true;
    openFirewall = !config.niksos.portable;
    settings.UseDns = true;
  };
}
