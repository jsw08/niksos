{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe;
in {
  programs.tofi = {
    inherit (osConfig.programs.hyprland) enable;
    settings = {
      terminal = "${getExe pkgs.foot}";

      "horizontal" = true;
      "anchor" = "top";
      "width" = "100%";
      "height" = 34;
      "outline-width" = 0;
      "border-width" = 0;
      "min-input-width" = 120;
      "result-spacing" = 30;
      "padding-top" = 7;
      "padding-bottom" = 7;
      "padding-left" = 20;
      "padding-right" = 0;
      "margin-top" = 0;
      "margin-bottom" = 0;
      "margin-left" = 15;
      "margin-right" = 0;
      "prompt-text" = " ";
      "prompt-padding" = 30;
      "prompt-background-padding" = "4, 10";
      "prompt-background-corner-radius" = 12;
      "input-background-padding" = "4, 10";
      "input-background-corner-radius" = 12;
      "selection-background-padding" = "4, 10";
      "selection-background-corner-radius" = 12;
      "clip-to-padding" = false;
    };
  };
}
