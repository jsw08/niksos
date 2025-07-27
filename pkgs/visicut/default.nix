{
  appimageTools,
  fetchurl,
  lib,
}: let
  pname = "VisiCut";
  version = "2.1";

  src = fetchurl {
    url = "https://github.com/t-oster/VisiCut/releases/download/${version}/VisiCut-${version}+devel-x86_64.AppImage";
    hash = "sha256-Mq6Rjozshwk8asY+5egScQ5TkoxzRnWlZ9p0WeEOoiE=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      substituteInPlace $out/${desktopFile} --replace-fail 'Exec=visicut' 'Exec=${pname}'
    '';
  };

  desktopFile = "VisiCut.desktop";
  iconFile = "visicut.png";
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${desktopFile} $out/share/applications/${desktopFile}
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/128x128/apps/${iconFile} \
        $out/share/icons/hicolor/128x128/apps/${iconFile}
    '';

    meta = {
      description = "A userfriendly tool to prepare, save and send Jobs to Lasercutters.";
      homepage = "https://visicut.org/";
      downloadPage = "https://github.com/t-oster/VisiCut/releases/";
      license = lib.licenses.lgpl3;
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      # maintainers = with lib.maintainers; [onny];
      mainProgram = "VisiCut";
      platforms = ["x86_64-linux"];
    };
  }
