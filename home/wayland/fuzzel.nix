{
  osConfig,
  pkgs,
  lib,
  ...
}: {
  programs.fuzzel = {
    enable = osConfig.niksos.desktop;
    settings.main = {
      launch-prefix = "${lib.getExe pkgs.uwsm} app --";
    };
  };
}
