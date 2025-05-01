{
  config,
  lib,
  ...
}: {
  networking.firewall.allowedTCPPorts = lib.mkOptionals config.niksos.desktop [8080]; # Handy for temporary web servers and stuff.
}
