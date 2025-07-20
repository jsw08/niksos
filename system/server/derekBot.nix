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
  path = builtins.concatStringsSep ":" (map (x: "${x}/bin/") [pkgs.coreutils pkgs.typst pkgs.deno]);
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

        mkdir -p "${programDir}" "${denoDir}"
        if [ -d "${programDir}" ]; then
          git clone "${gitRepo}"
        fi
        chmod -R 750 ${mainDir}* || echo

        rm "${mainDir}/prodBot.json" || echo
        ln -s "${config.age.secrets.${userGroup}.path}" "${mainDir}/prodBot.json"

        cd "${programDir}"
        git fetch
        git reset --hard HEAD

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
