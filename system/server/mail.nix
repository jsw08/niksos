{
  config,
  lib,
  ...
}: {
  #FIXME: revert when stopped using docker for stalwart. https://github.com/NixOS/nixpkgs/issues/416091 (look at older commits for previous code.)

  config = lib.mkIf config.niksos.server {
    virtualisation.oci-containers.containers.stalwart = {
      image = "docker.io/stalwartlabs/stalwart:latest";
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = ["25:25" "465:465" "993:993" "9003:8080"];
      volumes = [
        "/opt/stalwart:/opt/stalwart"
      ];
    };
    networking.firewall.allowedTCPPorts = [
      993
      25
      465
    ];

    services.caddy.virtualHosts."mail.jsw.tf".extraConfig = ''
      reverse_proxy http://127.0.0.1:9003
    '';
  };
}
