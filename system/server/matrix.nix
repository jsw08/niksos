{
  config,
  lib,
  ...
}: let
  name = "matrix";
  cfg = import ./lib/extractWebOptions.nix {inherit config name;};
in {
  options = import ./lib/webOptions.nix {inherit config lib name;};

  config = lib.mkIf cfg.enable {
    services = {
      matrix-continuwuity = {
        enable = true;
        group = "caddy"; # Permissions for socket
        #FIXME: caddy should be part of matrix group, not other way around
        settings.global = {
          unix_socket_path = "/run/continuwuity/continuwuity.sock";
          server_name = cfg.domain;
          allow_registration = true;
          registration_token_file = config.age.secrets.matrix-registration.path;
          new_user_displayname_suffix = "";
        };
      };

      caddy = {
        enable = true;
        virtualHosts = {
          ${cfg.domain}.extraConfig = ''
            header /.well-known/matrix/* Content-Type application/json
            header /.well-known/matrix/* Access-Control-Allow-Origin *
            respond /.well-known/matrix/server `{"m.server": "${cfg.domain}:443"}`
            respond /.well-known/matrix/client `{"m.homeserver": {"base_url": "https://${cfg.domain}"}}`
            reverse_proxy /_matrix/* unix//run/continuwuity/continuwuity.sock
          '';
        };
      };
    };
  };
}
