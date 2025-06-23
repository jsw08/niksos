{
  config,
  osConfig,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) getExe;
  inherit (config.lib.stylix.colors) base0D;
  inherit (osConfig.niksos) games portable;

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

  foot = appE config.programs.foot.package;
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

  somcli = let
    somSleep = pkgs.writeShellScriptBin "somsleep" ''
      ${getExe inputs.somcli.defaultPackage.${pkgs.system}} && sleep 5
    '';
    termSom = pkgs.writeShellScriptBin "somfoot" ''
      ${foot} -a "foot-somcli" ${getExe somSleep}
    '';
  in
    appE termSom;

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
        "$m, ${ws}, workspace, ${toString (x + 1)}"
        "$m SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
      ]
    )
    10);
in {
  wayland.windowManager.hyprland.settings = {
    "$m" = "ALT";

    bindm = [
      "$m, mouse:272, movewindow"
      "$m, mouse:273, resizewindow"
      "$m ALT, mouse:272, resizewindow"
    ];

    bind =
      [
        "$m SHIFT, E, exec, uwsm stop"
        "$m, Q, killactive,"
        "$m, F, fullscreen,"
        "$m, SPACE, togglefloating,"
        "$m, O, pseudo,"
        "$m ALT, ,resizeactive,"

        "$m, D, exec, ${fuzzel}"
        "$m, Return, exec, ${foot}"
        "$m Shift, Return, exec, ${firefox}"
        "$m, Escape, exec, ${hyprlock}"

        "$m, A, exec, ${pulsemixer}"
        "$m, B, exec, ${bluetui}"
        "$m, N, exec, ${nmtui}"
        ''
          $m, S, exec, bash -c 'hyprctl notify -1 5000 "rgb(${base0D})" "$(${getExe (import ./scripts.nix {inherit pkgs;}).statusnotify})"'
        ''

        "$m, Print, exec, ${grimblast} copy area"
        ", Print, exec, ${grimblast} save area - | ${swappy} -f -"

        "$m, h, movefocus, l"
        "$m, l, movefocus, r"
        "$m, k, movefocus, u"
        "$m, j, movefocus, d"

        "$m SHIFT, h, movewindow, l"
        "$m SHIFT, l, movewindow, r"
        "$m SHIFT, k, movewindow, u"
        "$m SHIFT, j, movewindow, d"
      ]
      ++ workspaces
      ++ lib.optionals games (let
        torzu = "${
          appE inputs.nixpkgs-torzu.legacyPackages.${pkgs.system}.torzu
        } -ql";
        dolphin = appE pkgs.dolphin-emu;
      in [
        "Super, s, exec, ${torzu}"
        "Super, d, exec, ${dolphin}"
      ])
      ++ lib.optionals portable.enable [
        "$m Shift, S, exec, ${somcli}"
        ", XF86AudioMedia, exec, powermode toggle"
      ];

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
