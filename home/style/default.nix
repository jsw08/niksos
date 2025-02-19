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
      package = pkgs.tela-circle-icon-theme; #FIXME: Swap out for normal tela icons once https://github.com/NixOS/nixpkgs/issues/381521 is upstream.
      dark = "Tela-circle-dark";
      light = "Tela-circle-dark";
    };

    #    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";
  };
}
