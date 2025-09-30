{
  config,
  name,
}: let
  inherit (config.niksos) server;
  inherit (server) baseDomain;
  cfg = server.${name};

  subDomain =
    if cfg.subDomain == ""
    then ""
    else "${cfg.subDomain}.";
in
  cfg
  // {
    domain = "${subDomain}${baseDomain}";
    inherit baseDomain subDomain;
  }
