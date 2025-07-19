self: super:
{
  reaper = super.reaper.overrideAttrs (oldAttrs: {
  installPhase =
    if super.stdenv.hostPlatform.isDarwin then
      ''
        runHook preInstall
        mkdir -p "$out/Applications/Reaper.app"
        cp -r * "$out/Applications/Reaper.app/"
        makeWrapper "$out/Applications/Reaper.app/Contents/MacOS/REAPER" "$out/bin/reaper"
        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        HOME="$out/share" XDG_DATA_HOME="$out/share" ./install-reaper.sh \
          --install $out/opt \
          --integrate-user-desktop
        rm $out/opt/REAPER/uninstall-reaper.sh

        # This overlay exists because some scripts needed extra runtime dependencies.
        wrapProgram $out/opt/REAPER/reaper \
          --prefix LD_LIBRARY_PATH : "${
            super.lib.makeLibraryPath [
              super.curl
              super.lame
              super.libxml2
              super.ffmpeg
              super.vlc
              super.xdotool
              super.stdenv.cc.cc

              super.freetype
              super.fontconfig
              super.libpng
              super.libepoxy
              super.gtk3
              super.cairo
              super.glib
              super.gdk-pixbuf
              super.pango
            ]
          }"

        mkdir $out/bin
        ln -s $out/opt/REAPER/reaper $out/bin/

        runHook postInstall
      '';
  });
}
