#WARNING: deprecated
{
  #   config,
  #   pkgs,
  #   lib,
  #   inputs,
  #   ...
  # }: {
  #   config = lib.mkIf config.niksos.server {
  #     # NOTE: allows me to spin up temporarily services.
  #     services.caddy.virtualHosts."temp.jsw.tf".extraConfig = ''
  #       reverse_proxy :8000
  #     '';
  #   };
}
