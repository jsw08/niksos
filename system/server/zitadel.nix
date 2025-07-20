{
  config,
  lib,
  ...
}: let
  ExternalDomain = "z.jsw.tf";
  Port = 9000;
in {
  config =
    lib.mkIf config.niksos.server
    {
      services.caddy.virtualHosts.${ExternalDomain}.extraConfig = ''
        reverse_proxy localhost:${builtins.toString Port}
      '';

      services.zitadel = {
        enable = true;
        masterKeyFile = config.age.secrets.zitadel-key.path;
        settings = {
          inherit Port ExternalDomain;
          ExternalPort = 443;
        };
        extraSettingsPaths = [config.age.secrets.zitadel.path];
      };
    };
}
