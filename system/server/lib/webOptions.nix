{
  config,
  lib,
  name,
}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  niksos.server.${name} = {
    enable = mkEnableOption name;
    subDomain = mkOption {
      type = types.lines;
      description = "What subdomain to use for ${name}";
      example = name;
    };
  };
}
