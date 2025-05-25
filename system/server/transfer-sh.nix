{config, ...}: {
  services.transfer-sh = {
    enable = config.niksos.server;
    settings = {
      PURGE_DAYS = 7;
      MAX_UPLOAD_SIZE = 4 * 1000 * 1000; # 4gb
      # CORS_DOMAINS = "transfer.jsw.tf"; #FIXME: open it to the world wide web.
      BASEDIR = "/var/lib/transfer.sh";
      LISTENER = ":9000";
      HTTP_AUTH_USER = "jsw";
      EMAIL_CONTACT = "jurnwubben@gmail.com";
    };
    secretFile = config.age.secrets.transferSh.path;
  };
  systemd.services.transfer-sh.serviceConfig = {
    StateDirectory = "transfer.sh";
    StateDirectoryMode = "0750";
  };

  services.caddy.virtualHosts."share.jsw.tf" = {
    extraConfig = ''
      reverse_proxy :9000
    '';
  };
}
