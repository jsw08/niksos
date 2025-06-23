{
  programs = {
    git = {
      enable = true;
      userEmail = "jurnwubben@gmail.com";
      userName = "Jurn Wubben";
      extraConfig.push.autoSetupRemote = true;
    };
    git-credential-oauth = true;
  };
}
