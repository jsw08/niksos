{
  config,
  lib,
  ...
}: {
  services.caddy.virtualHosts."jsw.tf" = lib.mkIf config.niksos.server {
    extraConfig = ''
      header Content-Type text/html
      respond <<HTML
        ${builtins.readFile ./index.html}
      HTML 200
    '';
  };
}
