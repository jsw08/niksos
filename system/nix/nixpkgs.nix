{
  config,
  pkgs,
  lib,
  ...
}: {
  nixpkgs = {
    config.allowUnfree = true;
  };
  environment.etc."current-system-packages".text = let
    packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
    sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
    formatted = builtins.concatStringsSep "\n" sortedUnique;
  in
    formatted;

  environment.etc."current-user-packages".text = let
    inherit (config.home-manager) users;
    packages = lib.lists.flatten (builtins.map (u: builtins.map (p: "${u}: ${p.name}") users.${u}.home.packages) (builtins.attrNames users));
    sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
    formatted = builtins.concatStringsSep "\n" sortedUnique;
  in
    formatted;
}
