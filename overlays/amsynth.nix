self: super:
{
  amsynth = (super.stdenv.mkDerivation rec {
    name = "amsynth";
    version = "1.13.4";
    src = super.fetchFromGitHub {
      owner = "amsynth";
      repo = "amsynth";
      tag = "release-${version}";
      sha256 = "sha256-7ftkp+c6MJi3am7UETqO87AuDu7hUGDbwve4APYaGa8=";
    };
    
    nativeBuildInputs = with super; [
      autoPatchelfHook
    ];

    buildInputs = with super; [
      gnumake
      automake
      autoconf
      intltool
      gettext
      liblo
      libtool
      alsa-lib
      libjack2
      autoconf-archive
      pkg-config
      gtk2
      freetype
      libpng
      pandoc
      curl
      xorg.libXcursor
      xorg.libXinerama
      xorg.xrandr
      zlib
    ];
    buildPhase = ''
      ./autogen.sh
      ./configure
      make
    '';
    installPhase = ''
      mkdir -p $out/lib/vst
      cp -r .libs/amsynth_vst.so $out/lib/vst
    '';
  });
}

