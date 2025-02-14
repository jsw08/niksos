{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  environment.systemPackages = [
    pkgs.kitty # This is the default config's terminal and also my main one.
  ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Makes electron apps use wayland.
}
