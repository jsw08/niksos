{
  programs.foot = {
    enable = true;
    settings = {};
  };

  xdg.desktopEntries = builtins.listToAttrs (map (x: {
    name = "${x}";
    value = {
      name = "";
      noDisplay = true;
    };
  }) ["footclient" "foot-server"]);
}
