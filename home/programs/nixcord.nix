{
  inputs,
  osConfig,
  ...
}: {
  imports = [inputs.nixcord.homeManagerModules.nixcord];

  programs.nixcord = {
    enable = osConfig.niksos.neovim;

    discord.enable = false;
    vesktop.enable = true;
    vesktopConfig = {
      tray = false;
      minimizeToTray = false;
      enableSplashScreen = false;
    };

    config = {
      frameless = true;
      transparent = true;

      plugins = let
        enabledPlugins = [
          # Plugins without config
          "anonymiseFileNames"
          "betterRoleDot"
          "betterSettings"
          "biggerStreamPreview"
          "callTimer"
          "clearURLs"
          "copyFileContents"
          "emoteCloner"
          "fakeNitro"
          "fixYoutubeEmbeds"
          "friendsSince"
          "fullSearchContext"
          "memberCount"
          "mentionAvatars"
          "noUnblockToJump"
          "openInApp"
          "petpet"
          "previewMessage"
          "quickReply"
          "relationshipNotifier"
          "secretRingToneEnabler"
          "shikiCodeblocks"
          "showHiddenChannels"
          "showHiddenThings"
          "showMeYourName"
          "unindent"
          "userVoiceShow"
          "youtubeAdblock"
          "webScreenShareFixes"
        ];
      in
        (builtins.listToAttrs (map (x: {
            name = x;
            value = {enable = true;};
          })
          enabledPlugins))
        // {
          # Plugins with config
        };
    };
  };
}
