{lib, ...}: {
  imports = [
    # ./matrix.nix
    ./bot.nix
    ./caddy.nix
    ./derekBot.nix
    ./forgejo.nix
    ./immich.nix
    ./index
    ./mail.nix
    ./nextcloud.nix
    ./temp.nix
    ./zitadel.nix
  ];
  options.niksos.server = lib.mkEnableOption "server servcies (such as caddy)."; #TODO: per service option.
}
