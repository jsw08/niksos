{
  imports = [
    ./hardware-configuration.nix
    ./virt.nix
    ./wluma.nix
  ];

  # programs.evolution.enable = true; # FIXME: move to appropiate place.
  niksos = {
    hardware = {
      joycond = false; #NOTE: enable when game night lol
      fingerprint = true;
      bluetooth = true;
      printer = true;

      portable = {
        enable = true;
        hyprland = {
          powerSaver = ''
            hyprctl keyword monitor eDP-1,2880x1920@60,0x0,1.5,vrr,1
          '';
          performance = ''
            hyprctl keyword monitor eDP-1,2880x1920@120,0x0,1.5,vrr,1
          '';
        };
      };
    };

    neovim = true;
    desktop = {
      games = true;
      enable = true;
      hyprland = true;
      kde = true;
    };
  };
  home-manager.users.jsw.wayland.windowManager.hyprland.settings.monitor = ["eDP-1,2880x1920@120,0x0,1.5,vrr,1"];

  services.udev.extraRules = ''
    # Ethernet expansion card support
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/autosuspend}="20"
  '';
  boot.kernelParams = [
    # There seems to be an issue with panel self-refresh (PSR) that
    # causes hangs for users.
    #
    # https://community.frame.work/t/fedora-kde-becomes-suddenly-slow/58459
    # https://gitlab.freedesktop.org/drm/amd/-/issues/3647
    "amdgpu.dcdebugmask=0x10"
  ];
}
