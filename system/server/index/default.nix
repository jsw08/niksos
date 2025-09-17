{
  config,
  lib,
  ...
}: let
  name = "site";
  cfg = import ../lib/extractWebOptions.nix {inherit config name;};
in {
  options = import ../lib/webOptions.nix {inherit config lib name;};
  config = lib.mkIf cfg.enable {
    services.caddy.virtualHosts.${cfg.domain} = {
      extraConfig = ''
        header Content-Type text/html
        respond <<HTML
          ${builtins.readFile ./index.html}
        HTML 200
      '';
    };
  };
}
