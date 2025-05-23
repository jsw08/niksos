{
  pkgs,
  inputs,
  ...
}: {
  environment.defaultPackages = [
    pkgs.git # We need git for flakes
    pkgs.neovim
    inputs.agenix.packages.${pkgs.system}.default
    pkgs.rsync
  ]; # Still have to be able to edit configs.
  environment.sessionVariables = {EDITOR = "nvim";};
}
