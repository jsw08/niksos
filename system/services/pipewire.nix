{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.niksos.desktop {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;

      extraConfig.pipewire = {
        "10-combined-sink" = {
          "context.modules" = [
            {
              name = "libpipewire-module-combine-stream";
              args = {
                "combine.mode" = "sink";
                "node.name" = "combined_sink";
                "node.description" = "All audio outputs combined.";
                "combine.latency-compensate" = false;
                "combine.props" = {
                  "audio.position" = ["FL" "FR"];
                };
                "stream.props" = {};
                "stream.rules" = [
                  {
                    matches = [
                      {
                        "media.class" = "Audio/Sink";
                      }
                    ];
                    actions = {
                      create-stream = {};
                    };
                  }
                ];
              };
            }
          ];
        };
      };
    };

    environment.systemPackages = [pkgs.pulsemixer];
    services.pulseaudio.enable = lib.mkForce false; # gnome enables it
  };
}
