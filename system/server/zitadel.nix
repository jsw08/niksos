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

      # services.zitadel = {
      #   enable = true;
      #   masterKeyFile = config.age.secrets.zitadel-key.path;
      #   settings = {
      #     inherit Port ExternalDomain;
      #     ExternalPort = 443;
      #   };
      #   extraSettingsPaths = [config.age.secrets.zitadel.path];
      # };
      systemd.services.zitadel = {
        requires = ["postgresql.service"];
        after = ["postgresql.service"];
      };

      services = {
        zitadel = {
          enable = true;
          masterKeyFile = config.age.secrets.zitadel-key.path;
          settings = {
            inherit Port ExternalDomain;
            ExternalPort = 443;
            Database.postgres = {
              Host = "/var/run/postgresql/";
              Port = 5432;
              Database = "zitadel";
              User = {
                Username = "zitadel";
                SSL.Mode = "disable";
              };
              Admin = {
                Username = "zitadel";
                SSL.Mode = "disable";
                ExistingDatabase = "zitadel";
              };
            };
            ExternalSecure = true;
          };
          steps.FirstInstance = {
            InstanceName = "jsw";
            Org = {
              Name = "jsw";
              Human = {
                UserName = "jsw@jsw.tf";
                FirstName = "Jurn";
                LastName = "Wubben";
                Email.Verified = true;
                Password = "Changeme1!";
                PasswordChangeRequired = true;
              };
            };
            LoginPolicy.AllowRegister = false;
          };
          openFirewall = true;
        };

        postgresql = {
          enable = true;
          enableJIT = true;
          ensureDatabases = ["zitadel"];
          ensureUsers = [
            {
              name = "zitadel";
              ensureDBOwnership = true;
              ensureClauses.login = true;
              ensureClauses.superuser = true;
            }
          ];
        };
      };
    };
}
