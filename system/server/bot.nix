{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  deno = lib.getExe pkgs.deno;
  bash = lib.getExe pkgs.bash;

  mainDir = "/var/lib/dcbot/";
  programDir = mainDir + "program";
  dataDir = mainDir + "data";
  denoDir = mainDir + "deno";

  path = builtins.concatStringsSep ":" (map (x: "${x}/bin/") [pkgs.coreutils pkgs.typst pkgs.deno]);
in {
  config = lib.mkIf config.niksos.server {
    systemd.services.dcbot = {
      enable = true;
      after = ["network.target"];
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

        chown -R dcbot:dcbot ${mainDir}* || echo
        chmod -R 750 ${mainDir}* || echo
        cp --no-preserve=mode,ownership -r ${inputs.dcbot}/* "${programDir}/"

        rm "${dataDir}/.env" || echo
        ln -s "${config.age.secrets.dcbot.path}" "${dataDir}/.env"

        cd "${programDir}"
        DENO_DIR=${denoDir} deno i
      '';

      serviceConfig = {
        StateDirectory = "dcbot";
        ExecStart = "${bash} -c 'cd ${dataDir} && deno run -A ${programDir}/src/main.ts'";
        User = "dcbot";
        Group = "dcbot";
        Restart = "always";
      };
    };

    services.caddy.virtualHosts."dc.jsw.tf" = {
      serverAliases = ["www.dc.jsw.tf"];
      extraConfig = ''
        reverse_proxy :9001
      '';
    };

    users.groups."dcbot" = {};
    users.users."dcbot" = {
      group = "dcbot";
      isSystemUser = true;
    };
  };
}
