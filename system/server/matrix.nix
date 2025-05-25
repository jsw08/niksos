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
in {
  config = lib.mkIf config.niksos.server {
    services = {
      dendrite = {
        enable = true;
        loadCredential = [
          # $ nix-shell -p dendrite --run 'generate-keys --private-key /tmp/key'
          "matrix-server-key:${config.age.secrets.matrix-priv.path}"
        ];
        environmentFile = config.age.secrets.matrix-registration.path; # Contains: `REGISTRATION_SHARED_SECRET=verysecretpassword`
        # openRegistration = true;

        settings = {
          global = {
            inherit database;
            server_name = "matrix.jsw.tf";
            private_key = "/$CREDENTIALS_DIRECTORY/matrix-server-key"; #nix shell nixpkgs#dendrite; generate-keys --private-key matrix_key.pem
          };
          app_service_api.database = database;
          federation_api.database = database;
          key_server.database = database;
          media_api.database = database;
          mscs.database = database;
          relay_api.database = database;
          room_server.database = database;
          sync_api.database = database;
          user_api.account_database.database = database;
          user_api.device_database.database = database;
          sync_api.search.enabled = true;
        };
      };

      postgresql = {
        enable = true;
        enableTCPIP = false;
        ensureDatabases = ["dendrite"];
        ensureUsers = [
          {
            name = "dendrite";
            ensureDBOwnership = true;
          }
        ];
      };

      caddy.virtualHosts = {
        "matrix.jsw.tf".extraConfig = ''
          header /.well-known/matrix/* Content-Type application/json
          header /.well-known/matrix/* Access-Control-Allow-Origin *
          respond /.well-known/matrix/server `{"m.server": "matrix.jsw.tf:443"}`
          respond /.well-known/matrix/client `{"m.homeserver": {"base_url": "https://matrix.jsw.tf"}}`
          reverse_proxy /_matrix/* localhost:8008
        '';
      };
    };

    systemd.services.dendrite.after = ["postgresql.service"];
  };
}
