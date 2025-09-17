{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./virt.nix
  ];

  # programs.appimage.enable = true;
  # programs.evolution.enable = true; # TODO: move to appropiate place.

  niksos = {
    hardware = {
      joycond = false; #NOTE: enable when game night lol
      fingerprint = true;
      bluetooth = true;
      printer = false;

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
      apps = true;
      enable = true;
      hyprland = true;
      kde = true;
    };
  };
  home-manager.users.jsw.wayland.windowManager.hyprland.settings.monitor = ["eDP-1,2880x1920@120,0x0,1.5,vrr,1"];

  #FIXME: unity
  nixpkgs.config.permittedInsecurePackages = ["libxml2-2.13.8"];
  environment = {
    etc.vscode.source = lib.getExe pkgs.vscodium;
    systemPackages = let
      unityhub = pkgs.unityhub.overrideAttrs (prevAttrs: {
        nativeBuildInputs = (prevAttrs.nativeBuildInputs or []) ++ [pkgs.makeBinaryWrapper];

        postInstall =
          (prevAttrs.postInstall or "")
          + ''
            wrapProgram $out/bin/unityhub --set GDK_SCALE 2 --set GDK_DPI_SCALE 0.5
          '';
      });
    in [
      unityhub
    ];
  };
  #ENDFIXME

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
