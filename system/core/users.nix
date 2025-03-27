{
  config,
  pkgs,
  ...
}: {
  users.users.jsw = {
    isNormalUser = true;
    shell = pkgs.fish;
    hashedPasswordFile = config.age.secrets.password.path;
    extraGroups = [
      "libvirtd"
      "NetworkManager"
      "plugdev"
      "dialout"
      "wheel"
    ];
  };
}
