{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) optionals mkEnableOption mkDefault;
  inherit (config.niksos) graphics;
  inherit (graphics) enable;

  nvidia = graphics.enable && graphics.nvidia;
  intel = graphics.enable && graphics.intel;
in {
  options.niksos.graphics = {
    enable = mkEnableOption "core graphics";
    intel = mkEnableOption "additional intel drivers";
    nvidia = mkEnableOption "additoinal nvidia drivers";
  };

  config = {
    niksos.graphics.enable = mkDefault true;

    hardware.graphics = {
      inherit enable;
      enable32Bit = enable;
      extraPackages = with pkgs;
        [
          libva
          vaapiVdpau
          libvdpau-va-gl
        ]
        ++ optionals intel [
          pkgs.intel-media-driver
        ]
        ++ optionals nvidia [
          nvidia-vaapi-driver
        ];
      extraPackages32 = with pkgs.pkgsi686Linux;
        [
          libva
          vaapiVdpau
          libvdpau-va-gl
        ]
        ++ optionals intel [
          pkgs.pkgsi686Linux.intel-media-driver
        ]
        ++ optionals nvidia [
          pkgs.pkgsi686Linux.nvidia-vaapi-driver
        ];
    };

    hardware.nvidia = {
      modesetting.enable = nvidia;
      open = false;
    };
    services.xserver.videoDrivers = optionals nvidia ["nvidia"];
  };
}
