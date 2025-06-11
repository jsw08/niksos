{lib, ...}: {
  imports = [./caddy.nix ./transfer-sh.nix ./seafile.nix ./bot.nix ./immich.nix ./matrix.nix ./mail.nix];
  options.niksos.server = lib.mkEnableOption "server servcies (such as caddy)."; #TODO: per service option.
}
