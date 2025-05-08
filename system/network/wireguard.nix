{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf optionals;
  inherit (config.networking) hostName;
  iptables = lib.getExe' pkgs.iptables "iptables";

  port = 53;
  server = "lapserv";

  serverCfg = {
    externalInterface = "eth0";
    privateKeyFile = config.age.secrets.wg-lapserv-private.path;
    publicKey = "aM+OrvByr63RxKsU9hu0A1lKJr8fPHifHDhBekkHR0c=";
    publicIp = "80.242.224.170";
    ip = "10.100.0.1";
  };
  deviceConfig = {
    laptop = {
      publicKey = config.age.secrets.wg-laptop-private.path;
      privateKeyFile = "1su1FfHuEYIvJLaZPwpN86kmH19d/NH/zuh9DjIOyQI=";
      ip = "10.100.0.2";
    };
  };

  isServer = server == config.networking.hostName;
  currentConfig =
    if isServer
    then serverCfg
    else deviceConfig.${hostName};
in {
  networking.nat = mkIf isServer {
    enable = true;
    inherit (serverCfg) externalInterface;
    internalInterfaces = ["wg0"];
  };
  networking.firewall.allowedUDPPorts = [port];

  networking.wireguard.interfaces.wg0 = {
    inherit (currentConfig) privateKeyFile;

    listenPort = port;
    ips = ["${currentConfig.ip}/24"];

    peers =
      []
      ++ (optionals isServer (builtins.concatMap (x: {
          inherit (x) publicKey;
          allowedIPs = ["${x.ip}/32"];
        })
        (builtins.attrValues
          deviceConfig)))
      ++ (optionals (!isServer) [
        {
          inherit (serverCfg) publicKey;
          allowedIPs = ["0.0.0.0/0"];
          endpoint = "${serverCfg.publicIp}:${builtins.toString port}";
          persistentKeepalive = 25;
        }
      ]);

    postSetup = mkIf isServer ''
      ${iptables} -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${serverCfg.externalInterface} -j MASQUERADE
    '';
    postShutdown = mkIf isServer ''
      ${iptables} -t nat -D POSTROUTING -s 10.100.0.0/24 -o ${serverCfg.externalInterface} -j MASQUERADE
    '';
  };
}
