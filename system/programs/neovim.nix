{lib, ...}: {
  options.niksos.neovim = lib.mkEnableOption "the neovim editor";
  # The actual config resides in NixOS/home/programs/neovim.
  # NOTE: This is for the customisation of the neovim editor, which uses a lot of disk space. Barebones version will be installed anyhow.
}
