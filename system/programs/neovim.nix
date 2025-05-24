{
  config,
  lib,
  ...
}: {
  options.niksos.neovim = lib.mkEnableOption "the neovim editor";

  config.assertions = lib.mkIf config.niksos.neovim [
    {
      assertion = config.niksos.desktop.enable;
      message = "The neovim option needs desktop enabled to work properly (it enables home-manager).";
    }
  ];
  # The actual config resides in NixOS/home/programs/neovim.
  # NOTE: This is for the customisation of the neovim editor, which uses a lot of disk space. Barebones version will be installed anyhow.
}
