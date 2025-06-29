{
  programs = {
    git = {
      enable = true;
      userEmail = "jurnwubben@gmail.com";
      userName = "Jurn Wubben";
      extraConfig.push.autoSetupRemote = true;
      lfs.enable = true;
    };
    git-credential-oauth.enable = true;
  };
}
