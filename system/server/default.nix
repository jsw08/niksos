{lib, ...}: {
  imports = [./caddy.nix ./transfer-sh.nix ./seafile.nix ./bot.nix ./immich.nix];
  options.niksos.server = lib.mkEnableOption "server servcies (such as caddy)."; #TODO: per service option.
}
