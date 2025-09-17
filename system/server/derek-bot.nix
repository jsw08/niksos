{
  config,
  pkgs,
  lib,
  ...
}: let
  name = "derek-bot";
  cfg = config.niksos.server.${name}.enable;

  userGroup = name;
  gitRepo = "https://github.com/The-Breadening/Breadener";

  inherit (lib) getExe mkEnableOption mkIf;
  bash = getExe pkgs.bash;

  varLib = "/var/lib/";
  mainDir = "${varLib}${userGroup}";
  programDir = "${mainDir}/program";
  denoDir = "${mainDir}/deno";
  tokenDir = "${mainDir}/Breadener-token";

  path = builtins.concatStringsSep ":" (map (x: "${x}/bin/") [pkgs.coreutils pkgs.deno pkgs.git]);
in {
  options.niksos.server.${name}.enable = mkEnableOption name;

  config = mkIf cfg {
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
        chown -R ${userGroup}:${userGroup} ${mainDir}/* || echo

        rm -rf "${tokenDir}" || echo
        mkdir -p "${denoDir}" "${tokenDir}"
        ln -s "${config.age.secrets.${userGroup}.path}" "${tokenDir}/prodBot.json"

        if [ ! -d "${programDir}" ]; then
          git clone "${gitRepo}" "${programDir}"
        fi
        chmod -R 750 ${mainDir}/* || echo


        cd "${programDir}"
        git fetch
        git reset --hard origin/HEAD

        cat > .env <<EOF
        DATABASE_PATH='../daataabaasaa.db'
        SECRETS_PATH='../Breadener-token/prodBot.json'
        EOF

        DENO_DIR=${denoDir} deno i
      '';

      serviceConfig = {
        StateDirectory = userGroup;
        ExecStart = "${bash} -c 'cd ${programDir} && deno run prod'";
        User = userGroup;
        Group = userGroup;
        Restart = "always";
        RuntimeMaxSec = 1 * 60 * 60; # 1h * 60min * 60s
      };
    };

    users.groups.${userGroup} = {};
    users.users.${userGroup} = {
      group = userGroup;
      isSystemUser = true;
    };
  };
}
