{
  pkgs,
  lib,
  osConfig,
  self,
  ...
}: {
  home.packages =
    lib.optionals osConfig.niksos.desktop.apps [
      pkgs.spotify
      pkgs.signal-desktop
      # pkgs.orca-slicer # FIXME: Webkit is outdated.
      pkgs.gimp
      pkgs.inkscape
      pkgs.thunderbird
      pkgs.stremio
    ]
    ++ lib.optional osConfig.niksos.hardware.portable.enable self.packages.${pkgs.system}.visicut;
}
