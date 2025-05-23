# networking configuration
{pkgs, ...}: {
  imports = [
    ./avahi.nix
    ./tailscale.nix
  ];

  #FIXME:
  networking = {
    # use quad9 with DNS over TLS
    nameservers = ["9.9.9.9#dns.quad9.net"];
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.powersave = true;
    };
  };
  users.groups.NetworkManager = {};

  services.resolved = {
    # DNS resolver that tries to encrypt dns traffic
    enable = true;
    dnsovertls = "opportunistic";
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
