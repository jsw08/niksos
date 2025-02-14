{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.fuzzel = {
    enable = true;
    settings.main = {
      launch-prefix = "${lib.getExe pkgs.uwsm} app --";
    };
  };
}
