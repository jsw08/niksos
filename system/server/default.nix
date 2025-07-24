{lib, ...}: {
  imports = [
    ./bot.nix
    ./caddy.nix
    ./derekBot.nix
    ./forgejo.nix
    ./immich.nix
    ./index
    ./mail.nix
    ./matrix.nix
    ./temp.nix
    ./zitadel.nix
  ];
  options.niksos.server = lib.mkEnableOption "server servcies (such as caddy)."; #TODO: per service option.
}
