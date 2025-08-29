{
  config,
  lib,
  ...
}: let
  name = "zitadel";
  cfg = import ./lib/extractWebOptions.nix {inherit config name;};

  Port = 9000;
in {
  options = import ./lib/webOptions.nix {inherit config lib name;};

  config =
    lib.mkIf cfg.enable
    {
      services.caddy = {
        enable = true;
        virtualHosts.${cfg.domain}.extraConfig = ''
          reverse_proxy localhost:${builtins.toString Port}
        '';
      };

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
            inherit Port;
            ExternalDomain = cfg.domain;
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
              Name = "jsw-admin";
              Human = {
                UserName = "jsw-admin@jsw.tf";
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
