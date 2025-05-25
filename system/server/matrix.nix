{
  config,
  lib,
  ...
}: let
  database = {
    connection_string = "postgres:///dendrite?host=/run/postgresql";
    max_open_conns = 97;
    max_idle_conns = 5;
    conn_max_lifetime = -1;
  };
  host = "matrix.jsw.tf";
in {
  config = lib.mkIf config.niksos.server {
    services = {
      matrix-continuwuity = {
        enable = true;
        group = "caddy"; # Permissions for socket
        settings.global = {
          unix_socket_path = "/run/continuwuity/continuwuity.sock";
          server_name = host;
          allow_registration = true;
          registration_token_file = config.age.secrets.matrix-registration.path;
        };
      };

      caddy.virtualHosts = {
        ${host}.extraConfig = ''
          header /.well-known/matrix/* Content-Type application/json
          header /.well-known/matrix/* Access-Control-Allow-Origin *
          respond /.well-known/matrix/server `{"m.server": "${host}:443"}`
          respond /.well-known/matrix/client `{"m.homeserver": {"base_url": "https://${host}"}}`
          reverse_proxy /_matrix/* unix//run/continuwuity/continuwuity.sock
        '';
      };
    };
  };
}
