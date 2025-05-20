{
  pkgs,
  inputs,
  ...
}: {
  environment.defaultPackages = [
    pkgs.neovim
    inputs.agenix.packages.${pkgs.system}.default
  ]; # Still have to be able to edit configs.
  environment.sessionVariables = {EDITOR = "nvim";};
}
