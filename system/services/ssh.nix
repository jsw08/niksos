{
  config,
  lib,
  ...
}: {
  services.openssh = {
    enable = true;
    openFirewall = !config.niksos.hardware.portable.enable;
    allowSFTP = false;

    # https://infosec.mozilla.org/guidelines/openssh#modern-openssh-67
    settings = {
      UseDns = lib.mkForce true; # Tailscale
      LogLevel = "VERBOSE";
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = true;

      KexAlgorithms = [
        "curve25519-sha256@libssh.org"
        "ecdh-sha2-nistp521"
        "ecdh-sha2-nistp384"
        "ecdh-sha2-nistp256"
        "diffie-hellman-group-exchange-sha256"
      ];
      Ciphers = [
        "chacha20-poly1305@openssh.com"
        "aes256-gcm@openssh.com"
        "aes128-gcm@openssh.com"
        "aes256-ctr"
        "aes192-ctr"
        "aes128-ctr"
      ];
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
        "hmac-sha2-512"
        "hmac-sha2-256"
        "umac-128@openssh.com"
      ];
    };

    extraConfig = ''
      ClientAliveCountMax 0
      ClientAliveInterval 300

      AllowAgentForwarding no
      MaxAuthTries 3
      MaxSessions 2
      TCPKeepAlive no
    '';
  };
}
