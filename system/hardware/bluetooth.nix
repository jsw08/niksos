# {
#   lib,
#   config,
#   ...
# }: {
#   options.niksos.bluetooth = lib.mkEnableOption;
#
#   config = lib.mkIf config.niksos.bluetooth {
#     hardware.bluetooth = {
#       enable = true;
#       input.General.ClassicBondedOnly = false;
#     };
#   };
# }
{
  hardware.bluetooth = {
    enable = true;
    input.General.ClassicBondedOnly = false;
  };
}
