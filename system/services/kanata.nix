{
  # keyboard remapping
  services.kanata = {
    enable = true;

    keyboards.default = {
      # i know this config is aweful but it does the job.
      config = ''
        (defsrc
          caps d w e b h j k l p
        )

        (deflayer default
          @cap _ _ _ _ _ _ _ _ _
        )

        (deflayer arrows
          _ @tablayer @nextword @nextword @prevword left down up right PrintScreen
        )

        (deflayer tabs
          _ _ _ _ _ @tableft _ _ @tabright _
        )


        (defalias
          cap (tap-hold-press 170 170 esc (layer-toggle arrows))

          nextword (multi lctrl right)
          prevword (multi lctrl left)

          tablayer (layer-while-held tabs)
          tableft (multi lctrl lshift tab)
          tabright (multi lctrl tab)
        )
      '';
    };
  };
}
