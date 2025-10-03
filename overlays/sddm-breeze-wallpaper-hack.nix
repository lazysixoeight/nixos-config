self: super:
{
  sddm-breeze-wallpaper-hack = super.runCommand "sddm-breeze-wallpaper-hack" {} ''
    cp ${./.wallpaper} $out
  '';
}
