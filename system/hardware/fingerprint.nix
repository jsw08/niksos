{
  config,
  lib,
  ...
}: {
  options.niksos.fingerprint = lib.mkEnableOption "fingerprint support.";
  config.services.fprintd.enable = config.niksos.fingerprint;
}
