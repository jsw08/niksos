{
  config,
  lib,
  ...
}: {
  programs =
    lib.mkIf config.niksos.desktop.enable
    {
      command-not-found.enable = false;
      nix-index.enable = true;
      nix-index-database.comma.enable = true;
    };
}
