{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];

  stylix = {
    enable = true;
    polarity = "dark";
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 21;
    };
    fonts.monospace = {
      name = "DejaVuSansMNerdFontMono-Regular";
      package = pkgs.nerd-fonts.dejavu-sans-mono;
    };

    #    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";
    image = ./background.png;
  };
}
