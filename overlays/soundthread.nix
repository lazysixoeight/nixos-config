self: super:
{
  soundthread = (super.stdenv.mkDerivation {
    name = "soundthread";
    src = super.fetchurl {
      url = "https://github.com/j-p-higgins/SoundThread/releases/download/v0.3.0-beta/SoundThread_v0.3.0-beta_linux.zip";
      sha256 = "sha256-rYsB9P1fQ++hgTBquKFazrOkoHnPpbnfck2KBMhIJ3I=";
    };
    nativeBuildInputs = with super; [
      makeWrapper
    ];

    buildInputs = with super; [
      unzip
    ];

    installPhase = ''
      unzip $src
      chmod +x SoundThread_v0.3.0-beta_linux/SoundThread.x86_64
      chmod +x SoundThread_v0.3.0-beta_linux/cdprogs_linux/*

      mkdir -p $out/bin
      mkdir -p $out/lib
      cp SoundThread_v0.3.0-beta_linux/SoundThread.x86_64 $out/bin/SoundThread
      cp -r SoundThread_v0.3.0-beta_linux/cdprogs_linux $out/lib/

      wrapProgram $out/bin/SoundThread \
        --prefix LD_LIBRARY_PATH : "${
            super.lib.makeLibraryPath [
              super.xorg.libXrender
              super.xorg.libXinerama
              super.xorg.libXfixes
              super.xorg.libXdamage
              super.xorg.libXcomposite
              super.xorg.libXrandr
              super.xorg.libXi
              super.xorg.libXext
              super.xorg.libXcursor
              super.xorg.libX11
              super.wayland
              super.libxkbcommon
              super.libGL

              super.libjack2
              super.alsa-lib
            ]
          }"
    '';
  });
}

