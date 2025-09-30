{
  config,
  pkgs,
  lib,
  ...
}: let
  name = "derek-site";
  cfg = config.niksos.server.${name}.enable;

  userGroup = name;
  gitRepo = "https://github.com/Definitely-Not-A-Dolphin/Geen-Dolfijn";

  inherit (lib) getExe mkEnableOption mkIf;
  bash = getExe pkgs.bash;

  varLib = "/var/lib/";
  mainDir = "${varLib}${userGroup}";
  programDir = "${mainDir}/program";
  denoDir = "${mainDir}/deno";

  path = builtins.concatStringsSep ":" (map (x: "${x}/bin/") [pkgs.coreutils pkgs.deno pkgs.git pkgs.nodejs]);
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

        if [ ! -d "${programDir}" ]; then
          git clone "${gitRepo}" "${programDir}"
        fi
        chmod -R 750 ${mainDir}/* || echo

        cd "${programDir}"
        git fetch
        git reset --hard origin/HEAD

        cp "${config.age.secrets.${userGroup}.path}" "./src/lib/secrets.json"

        DENO_DIR=${denoDir} deno i --allow-scripts=npm:workerd,npm:sharp
        DENO_DIR=${denoDir} deno run build || echo oopsie woopsie error
      '';

      serviceConfig = {
        StateDirectory = userGroup;
        ExecStart = "${bash} -c 'cd ${programDir} && deno run preview --port 9010'";
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
