{pkgs,...}: {
  environment.defaultPackages = [pkgs.neovim]; # Still have to be able to edit configs.
}
