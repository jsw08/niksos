{
  programs.nh = {
    enable = true;
    # weekly cleanup
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d";
    };
    flake = "/home/jsw/NiksOS";
  };
}
