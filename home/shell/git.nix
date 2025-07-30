{pkgs, ...}: {
  programs = {
    #NOTE: Disabled because read only git config is annoying.
    git = {
      enable = false;
      # userEmail = "jurnwubben@gmail.com";
      # userName = "Jurn Wubben";
      # extraConfig.push.autoSetupRemote = true;
      # lfs.enable = true;
    };
    # git-credential-oauth.enable = true; #FIXME: need to relogin for each push for some reason.
  };
  home.packages = [
    pkgs.git
    pkgs.git-lfs
    pkgs.git-credential-oauth
  ];
}
