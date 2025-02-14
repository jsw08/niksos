{pkgs, ...}: {
  users.users.jsw = {
    isNormalUser = true;
    shell = pkgs.fish;
    initialPassword = "changeme";
    extraGroups = [
      "libvirtd"
      "NetworkManager"
      "plugdev"
      "dialout"
      "wheel"
    ];
  };
}
