{lib, ...}: {
  imports = [./caddy.nix ./transfer-sh.nix];
  options.niksos.server = lib.mkEnableOption "server servcies (such as caddy)."; #TODO: per service option.
}
