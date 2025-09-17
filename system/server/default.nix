{lib, ...}: let
  inherit (lib) mkOption types;
in {
  imports = [
    # ./matrix.nix
    # ./temp.nix
    ./jsw-bot.nix
    ./caddy.nix
    ./derek-bot.nix
    ./forgejo.nix
    ./immich.nix
    ./index
    ./mail.nix
    ./nextcloud.nix
    ./zitadel.nix
  ];
  options.niksos.server = {
    baseDomain = mkOption {
      type = types.lines;
      description = "Set's the apex domain for the webservices. Do not include 'https' or a slash at the end. Just 'example.com'.";
      example = "example.com";
    };
  };
}
