{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  udisks2 = osConfig.services.udisks2.enable;
  yPlugins = pkgs.yaziPlugins;
in {
  programs.yazi = {
    enable = true;
    plugins = {
      full-border = yPlugins.full-border;
      mount = mkIf udisks2 yPlugins.mount;
    };
    keymap.manager.prepend_keymap =
      lib.optionals udisks2
      [
        {
          on = "M";
          run = "plugin mount";
        }
      ];
  };
}
