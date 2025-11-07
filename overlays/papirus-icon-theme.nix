self: super:
let
  icons = super.nicotine-plus;
in {
  papirus-icon-theme = super.papirus-icon-theme.overrideAttrs (old: {
    postInstall = ''
      # Swap the monochrome tray icons for the real thing
      find $out/share/icons/ -type f -ipath "*/panel/*nicotine*" -exec rm -v {} +
      for size in 16x16 22x22 24x24; do
        cp -v "${icons}/share/icons/hicolor/scalable/apps/org.nicotine_plus.Nicotine-away.svg" $out/share/icons/Papirus/$size/panel/
        cp -v "${icons}/share/icons/hicolor/scalable/apps/org.nicotine_plus.Nicotine-connect.svg" $out/share/icons/Papirus/$size/panel/
        cp -v "${icons}/share/icons/hicolor/scalable/apps/org.nicotine_plus.Nicotine-disconnect.svg" $out/share/icons/Papirus/$size/panel/
        cp -v "${icons}/share/icons/hicolor/scalable/apps/org.nicotine_plus.Nicotine-msg.svg" $out/share/icons/Papirus/$size/panel/
        cp -v "${icons}/share/icons/hicolor/scalable/apps/org.nicotine_plus.Nicotine.svg" $out/share/icons/Papirus/$size/panel/
      done
    '';
  });
}

