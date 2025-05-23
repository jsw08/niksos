{
  osConfig,
  pkgs,
  lib,
  ...
}: {
  stylix = {
    enable = true;
    autoEnable = lib.mkDefault true;

    image = ./background.png;
    polarity = "dark";

    fonts.monospace = {
      name = "DejaVuSansMNerdFontMono-Regular";
      package = pkgs.nerd-fonts.dejavu-sans-mono;
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 21;
    };
    iconTheme = {
      enable = true;
      package = pkgs.tela-icon-theme;
      dark = "Tela-dark";
      light = "Tela-dark";
    };

    targets.nvf.enable = false; # I'd like to be able to read my code, thank you.
    overlays.enable = false; # Should be set automatically but it isn't for some reason...
    #    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";
  };
}
