{config, ...}: {
  services.transfer-sh = {
    enable = config.niksos.server;
    settings = {
      PURGE_DAYS = 7;
      MAX_UPLOAD_SIZE = 4 * 1000 * 1000; # 2gb
      # CORS_DOMAINS = "transfer.jsw.tf"; #FIXME: open it to the world wide web.
      BASEDIR = "/var/lib/transfer.sh";
      LISTENER = ":9000";
    };
  };
  systemd.services.transfer-sh.serviceConfig = {
    StateDirectory = "transfer.sh";
    StateDirectoryMode = "0750";
  };

  #TODO: caddy
}
