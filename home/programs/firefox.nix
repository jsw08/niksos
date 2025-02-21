{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = true;
        PasswordManagerEnabled = false;
        PromptForDownloadLocation = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DisableProfileImport = true; # Nix profiles only!
        DisableProfileRefresh = true;
        DisableSetDesktopBackground = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
        };
        FirefoxHome = {
          "Search" = true;
          "TopSites" = true;
          "SponsoredTopSites" = false;
          "Highlights" = false;
          "Pocket" = false;
          "SponsoredPocket" = false;
        };
        FirefoxSuggest = {
          "WebSuggestions" = true;
        };

        ExtensionSettings = let
          mkForceInstalled = extensions:
            builtins.mapAttrs
            (_: cfg: {installation_mode = "force_installed";} // cfg)
            extensions;
        in
          mkForceInstalled {
            # You can find the addon-ids using this extension: https://github.com/mkaply/queryamoid/releases/tag/v0.1
            #"".install_url = ""; # Extension info here.

            "queryamoid@kaply.com".install_url = "https://github.com/mkaply/queryamoid/releases/download/v0.2/query_amo_addon_id-0.2-fx.xpi";
            "uBlock0@raymondhill.net".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"; # Ublock Origin
            "{446900e4-71c2-419f-a6a7-df9c091e268b}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi"; # Bitwarden
            "jid1-QoFqdK4qzUfGWQ@jetpack".install_url = "https://addons.mozilla.org/firefox/downloads/latest/dark-background-light-text/latest.xpi"; # Dark reader alternative
            "{34daeb50-c2d2-4f14-886a-7160b24d66a4}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-shorts-block/latest.xpi"; # Youtube short blocker
            "vimium-c@gdh1995.cn".install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-c/latest.xpi"; # Extension info here.
          };
      };
    };

    profiles."jsw.nixos-default" = {
      id = 0;
      name = "nixos-default";
      isDefault = true;

      search = {
        default = "DuckDuckGo";
        order = [
          "DuckDuckGo"
          "Google"
        ];
      };

      settings = {
        "middlemouse.paste" = false;

        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;

        "browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["ublock0_raymondhill_net-browser-action","queryamoid_kaply_com-browser-action","_34daeb50-c2d2-4f14-886a-7160b24d66a4_-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","customizableui-special-spring1","vertical-spacer","urlbar-container","customizableui-special-spring2","save-to-pocket-button","downloads-button","fxa-toolbar-menu-button","unified-extensions-button","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","jid1-qofqdk4qzufgwq_jetpack-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["firefox-view-button","tabbrowser-tabs","new-tab-button","alltabs-button"],"vertical-tabs":[],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","jid1-qofqdk4qzufgwq_jetpack-browser-action","ublock0_raymondhill_net-browser-action","queryamoid_kaply_com-browser-action","_34daeb50-c2d2-4f14-886a-7160b24d66a4_-browser-action","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"],"dirtyAreaCache":["nav-bar","vertical-tabs","PersonalToolbar","toolbar-menubar","TabsToolbar","unified-extensions-area"],"currentVersion":21,"newElementCount":2}'';
      };
    };
  };
}
