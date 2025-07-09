{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) optionals mkDefault;
  inherit (config.niksos.hardware) graphics;
  inherit (graphics) enable nvidia intel;

  Nvidia = enable && nvidia;
  Intel = enable && intel;
in {
  config = {
    niksos.hardware.graphics.enable = mkDefault true;

    hardware.graphics = {
      inherit enable;
      enable32Bit = enable;
      extraPackages = with pkgs;
        [
          libva
          vaapiVdpau
          libvdpau-va-gl
        ]
        ++ optionals Intel [
          pkgs.intel-media-driver
        ]
        ++ optionals Nvidia [
          nvidia-vaapi-driver
        ];
      extraPackages32 = with pkgs.pkgsi686Linux;
        [
          libva
          vaapiVdpau
          libvdpau-va-gl
        ]
        ++ optionals Intel [
          pkgs.pkgsi686Linux.intel-media-driver
        ]
        ++ optionals Nvidia [
          pkgs.pkgsi686Linux.nvidia-vaapi-driver
        ];
    };

    hardware.nvidia = {
      modesetting.enable = Nvidia;
      open = false;
    };
    services.xserver.videoDrivers = optionals Nvidia ["nvidia"];
  };
}
