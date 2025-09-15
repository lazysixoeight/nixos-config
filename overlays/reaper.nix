self: super:

let 
  pkgsStable = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/fe83bbdde2ccdc2cb9573aa846abe8363f79a97a.tar.gz";
    sha256 = "sha256:17dyfakqa9nafdwcwpndxj5807agw22iwzawicdvbnasfj615fiw";
  }) { inherit (super) system; };
in {
  reaper = super.reaper.overrideAttrs (oldAttrs: rec { 
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
                super.curlWithGnuTls
                super.lame
                pkgsStable.libxml2
                super.libz
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
