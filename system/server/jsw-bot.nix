{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  name = "jsw-bot";
  cfg = import ./lib/extractWebOptions.nix {inherit config name;};

  inherit (lib) getExe mkIf optional;
  inherit (config.niksos.server) nextcloud;

  bash = getExe pkgs.bash;

  mainDir = "/var/lib/${name}/";
  programDir = mainDir + "program";
  dataDir = mainDir + "data";
  denoDir = mainDir + "deno";

  path = builtins.concatStringsSep ":" (map (x: "${x}/bin/") [pkgs.coreutils pkgs.typst pkgs.deno]);
in {
  options = import ./lib/webOptions.nix {
    inherit config lib name;
  };

  config = mkIf cfg.enable {
    systemd.services.${name} = {
      enable = true;
      after = ["network.target"]; #FIXME: doesn't start after network.
      wantedBy = ["default.target"];
      description = "Jsw's slaafje, discord bot.";

      environment = {
        "DENO_DIR" = denoDir;
        "PATH" = lib.mkForce path;
      };

      preStart = ''
        export PATH=${path}

        cd "${mainDir}"
        mkdir -p "${programDir}" "${dataDir}" "${denoDir}"

        chown -R ${name}:${name} ${mainDir}* || echo
        chmod -R 750 ${mainDir}* || echo
        cp --no-preserve=mode,ownership -r ${inputs.dcbot}/* "${programDir}/"

        rm "${dataDir}/.env" || echo
        ln -s "${config.age.secrets.jsw-bot.path}" "${dataDir}/.env"

        cd "${programDir}"
        DENO_DIR=${denoDir} deno i
      '';

      serviceConfig = {
        StateDirectory = name;
        ExecStart = "${bash} -c 'cd ${dataDir} && deno run -A ${programDir}/src/main.ts'";
        User = name;
        Group = name;
        Restart = "always";
      };
    };

    services.caddy = {
      enable = true;
      virtualHosts.${cfg.domain} = {
        extraConfig = ''
          reverse_proxy :9001
        '';
      };
    };

    users.groups.${name} = {
      members = optional nextcloud.enable "nextcloud"; #TODO: if config.niksos.server.nextcloud
      #NOTE: for nextcloud mounted folder
    };
    users.users.${name} = {
      group = name;
      isSystemUser = true;
    };
  };
}
