{
  osConfig,
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];

  stylix = {
    enable = osConfig.niksos.desktop;

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

    targets = {
      gnome-text-editor.enable = false; # Creates an overlay in home-manager land which isn't allowed with globalPkgs.
      nvf.enable = false; # I'd like to be able to read my code, thank you.
    };

    #    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";
  };
}
