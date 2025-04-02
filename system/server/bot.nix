{
  inputs,
  pkgs,
  lib,
  ...
}: let
  deno = lib.getExe pkgs.deno;

  mainDir = "/var/lib/dcbot/";
  programDir = mainDir + "program";
  dataDir = mainDir + "data";

  config = pkgs.writeText ".env" ''
    config
  '';
in {
  systemd.services.dcbot = {
    enable = true;
    after = ["network.target"];
    wantedBy = ["default.target"];
    description = "Jsw's slaafje, discord bot.";

    preStart = ''
      mkdir -p "${programDir}" "${dataDir}/"

      cp -r ${inputs.dcbot}/* "${programDir}/"
      cp -r "${config}" "${programDir}/.env"

      cd "${programDir}"
      ${deno} i
    '';
    serviceConfig = {
      StateDirectory = "dcbot";
      ExecStart = "${deno} run -A ${programDir}/src/main.ts";
    };
  };
}
