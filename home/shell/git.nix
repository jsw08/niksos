{
  programs = {
    git = {
      enable = true;
      userEmail = "jurnwubben@gmail.com";
      userName = "Jurn Wubben";
      extraConfig.push.autoSetupRemote = true;
      lfs.enable = true;
    };
    git-credential-oauth.enable = true; #FIXME: need to relogin for each push for some reason.
  };
}
