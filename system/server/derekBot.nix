{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.niksos.server;
  userGroup = "bread-dcbot";
  gitRepo = "https://github.com/The-Breadening/Breadener";

  bash = lib.getExe pkgs.bash;
  varLib = "/var/lib/";
  mainDir =
    varLib
    + (
      if !cfg
      then ""
      else userGroup
    )
    + "/";
  programDir = mainDir + "program";
  denoDir = mainDir + "deno";
  tokenDir = mainDir + "Breadener-token";
  path = builtins.concatStringsSep ":" (map (x: "${x}/bin/") [pkgs.coreutils pkgs.deno pkgs.git]);
in {
  config = lib.mkIf config.niksos.server {
    systemd.services.${userGroup} = {
      enable = true;
      after = ["network.target"];
      wantedBy = ["default.target"];
      description = userGroup;

      environment = {
        "DENO_DIR" = denoDir;
        "PATH" = lib.mkForce path;
      };

      preStart = ''
        export PATH=${path}

        cd "${mainDir}"
        chown -R ${userGroup}:${userGroup} ${mainDir}* || echo

        rm -rf "${tokenDir}" || echo
        mkdir -p "${denoDir}" "${tokenDir}"
        ln -s "${config.age.secrets.${userGroup}.path}" "${tokenDir}/prodBot.json"

        if [ ! -d "${programDir}" ]; then
          git clone "${gitRepo}" "${programDir}"
        fi
        chmod -R 750 ${mainDir}* || echo


        cd "${programDir}"
        git fetch
        git reset --hard origin/HEAD

        DENO_DIR=${denoDir} deno i
      '';

      serviceConfig = {
        StateDirectory = userGroup;
        ExecStart = "${bash} -c 'cd ${programDir} && deno run prod'";
        User = userGroup;
        Group = userGroup;
        Restart = "always";
        RuntimeMaxSec = 6 * 60 * 60; # 6h * 60min * 60s
      };
    };

    users.groups.${userGroup} = {};
    users.users.${userGroup} = {
      group = userGroup;
      isSystemUser = true;
    };
  };
}
