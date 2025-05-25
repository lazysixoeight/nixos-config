self: super:
let
  icon = super.fetchurl {
    url = "https://warmplace.ru/forum/download/file.php?id=590&sid=1abb5220a869a90cd0d28d823617ca7e";
    sha256 = "sha256-uC8CWWMwtapGgGo08vevRl5lQ4pf/BR3Ke9o3oVA778=";
  };
in
{
  sunvox = super.sunvox.overrideAttrs (oldAttrs: {
    postInstall = ''
      mkdir -p $out/share/icons/hicolor/scalable/apps
      cp ${icon} $out/share/icons/hicolor/scalable/apps/sunvox.svg

      mkdir -p $out/share/applications
      cat <<INI > $out/share/applications/sunvox.desktop
      [Desktop Entry]
      Name=SunVox
      Exec=$out/bin/sunvox %f
      Icon=sunvox
      Categories=Audio
      Comment=Tracker-based music composition software
      Type=Application
      INI
    '';
  });
}
