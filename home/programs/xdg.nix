{
  xdg.mimeApps = let
    browser = "firefox.desktop";
    fileManager = "yazi.desktop";
    mailer = "thunderbird.desktop";
    photoedit = "gimp.desktop";
    vectoredit = "org.inkscape.Inkscape.desktop";
    modeledit = "BambuStudio.desktop";
    textedit = "nvim.desktop";
    mediaviewer = "mpv.desktop";

    associations = {
      "text/html" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/ftp" = browser;
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/unknown" = browser;
      "application/xhtml+xml" = browser;
      "application/x-extension-htm" = browser;
      "application/x-extension-html" = browser;
      "application/x-extension-shtml" = browser;
      "application/x-extension-xhtml" = browser;
      "application/x-extension-xht" = browser;
      "application/json" = browser;
      "application/pdf" = browser;

      "model/3mf" = modeledit;
      "model/stl" = modeledit;
      "inode/directory" = fileManager;
      "text/*" = textedit;
      # "application/x-xz-compressed-tar" = ["org.kde.ark.desktop"];

      "audio/*" = mediaviewer;
      "video/*" = mediaviewer;
      "image/*" = mediaviewer;
      "image/vnd.adobe.photoshop" = photoedit;
      "image/vnd.microsoft.icon" = photoedit;
      "image/vnd.zbrush.pcx" = photoedit;
      "image/x-gimp-gbr" = photoedit;
      "image/x-gimp-gih" = photoedit;
      "image/x-gimp-pat" = photoedit;
      "application/illustrator" = vectoredit;
      "application/vnd.corel-draw" = vectoredit;
      "application/vnd.visio" = vectoredit;

      "x-scheme-handler/mailto" = mailer;
      "text/calendar" = mailer;
      "text/vcard" = mailer;

      "x-scheme-handler/discord" = ["vesktop.desktop"];
      "x-scheme-handler/sgnl" = ["signal.desktop"];
      "x-scheme-handler/signalcaptcha" = ["signal.desktop"];
      "x-scheme-handler/spotify" = ["spotify.desktop"];
    };
  in {
    enable = true;
    associations.added = associations;
    defaultApplications = associations;
  };
}
