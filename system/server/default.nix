{lib, ...}: {
  imports = [./caddy.nix];
  options.niksos.server.enable = lib.mKEnableOption "server servcies (such as caddy).";
}
