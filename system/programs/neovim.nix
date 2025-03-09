{lib, ...}: {
  options.niksos.neovim = lib.mkEnableOption "the neovim editor";
  # The actual config resides in NixOS/home/programs/neovim.
}
