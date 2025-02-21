{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;
  inherit (config.lib.stylix.colors) base0D;

  runOnce = program: "pgrep ${program} || uwsm app -- ${program}";
  uwsm = getExe pkgs.uwsm;
  hyprlock = runOnce (getExe pkgs.hyprlock);

  #TODO: Move these functions into a separate lib file.
  #TODO: Possibly migrate some of these applications into an option.
  #TODO: Stylix
  app = app: "${uwsm} app -- ${app}";
  appE = appE: app (getExe appE);
  termapp = termapp: "${foot} '${termapp}'";
  termappE = termappE: termapp (getExe termappE);

  foot = appE pkgs.foot;
  fuzzel = appE config.programs.fuzzel.package;
  firefox = appE config.programs.firefox.package;
  playerctl = appE pkgs.playerctl;
  brightnessctl = appE pkgs.brightnessctl;
  wpctl = app "${pkgs.wireplumber}/bin/wpctl";
  grimblast = appE pkgs.grimblast;
  swappy = appE pkgs.swappy;

  pulsemixer = termappE pkgs.pulsemixer;
  bluetui = termappE pkgs.bluetui;
  nmtui = termapp "${pkgs.networkmanager}/bin/nmtui";

  # toggle = program: let
  #   prog = builtins.substring 0 14 program;
  # in "pkill ${prog} || ${uwsm} app -- ${program}";

  workspaces = builtins.concatLists (builtins.genList (
      x: let
        ws = let
          c = (x + 1) / 10;
        in
          builtins.toString (x + 1 - (c * 10));
      in [
        "$mod, ${ws}, workspace, ${toString (x + 1)}"
        "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
      ]
    )
    10);
in {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "ALT";

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod ALT, mouse:272, resizewindow"
    ];

    bind =
      [
        "$mod SHIFT, E, exec, uwsm stop"
        "$mod, Q, killactive,"
        "$mod, F, fullscreen,"
        "$mod, SPACE, togglefloating,"
        "$mod, O, pseudo,"
        "$mod ALT, ,resizeactive,"

        "$mod, D, exec, ${fuzzel}"
        "$mod, Return, exec, ${foot}"
        "$mod Shift, Return, exec, ${firefox}"
        "$mod, Escape, exec, ${hyprlock}"

        "$mod, A, exec, ${pulsemixer}"
        "$mod, B, exec, ${bluetui}"
        "$mod, N, exec, ${nmtui}"
        ''
          $mod, S, exec, bash -c 'hyprctl notify -1 5000 "rgb(${base0D})" "$(${getExe (import ./scripts.nix {inherit pkgs;}).statusnotify})"'
        ''

        "$mod, Print, exec, ${grimblast} copy area"
        ", Print, exec, ${grimblast} save area - | ${swappy} -f -"

        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"
      ]
      ++ workspaces;

    bindl = [
      # media controls
      ", XF86AudioPlay, exec, ${playerctl} play-pause"
      ", XF86AudioPrev, exec, ${playerctl} previous"
      ", XF86AudioNext, exec, ${playerctl} next"

      # volume
      ", XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ];

    bindle = [
      # volume
      ", XF86AudioRaiseVolume, exec, ${wpctl} set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+"
      ", XF86AudioLowerVolume, exec, ${wpctl} set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-"
      ",XF86MonBrightnessUp, exec, ${brightnessctl} s 10%+"
      ",XF86MonBrightnessDown, exec, ${brightnessctl} s 10%-"
    ];
  };
}
