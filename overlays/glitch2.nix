self: super:
{
  glitch2 = (super.stdenv.mkDerivation { 
    name = "glitch2";
    src = super.fetchurl {
      url = "https://www.dropbox.com/scl/fo/g2iard1i3w5bktq3z6hx7/AIHt1ddADv7lXyWvSsIzduM?rlkey=md2gq9qloqslbz2cdfl4ma6qw&st=orndwjmb&dl=1";
      hash = "sha256-pxOSBKHDU0U7JxzwWMrBOI31ww90nHtfqeoVmpnbVls=";
    };
    
    nativeBuildInputs = [ super.autoPatchelfHook super.unzip ];
    buildInputs = with super; [
      (super.stdenv.cc.cc)
      (super.stdenv.cc.cc.lib)
      alsa-lib
      xorg.libX11
      xorg.libXext
    ];

    unpackPhase = ''
      unzip "$src" -x /
    '';

    installPhase = ''
      mkdir -p $out/lib/vst/
      cp -r Glitch2_64bit $out/lib/vst/
    '';
  });
}


# Lucky you!
/*
-- COPY LICENSE KEY FROM HERE --
Product: TAL-Sampler
Licensee: 
D8cHy3Jjx7Lcxu8mw2yhrs9/anOwt3goEJ6N+LdFKs79WUiTTf8FY7+2Rp
ip6twgdlKVKJG05KA/Em+5WHa8+jBabrcnQTYeBB7QNwGIIS4R9UVV8Xd7
S23C9sem7HLS5y5ExmK8MyWUnrFEBhXLJMlf4g8ZB2MEje1X3qGx6hE=
-- COPY UNTIL HERE --
*/
/*
-- COPY LICENSE KEY FROM HERE --
Product: TAL-Drum
Licensee: 
UD8+jvpB8sItHRTk1eOyNaGlq8Q17lNd+/sY7O+rV+b9WCXTuox6Kmfroo
/mdyeiNeJBa7gIu+7rXCKYX44XYwSBOiIz4vrNNbbxUzyWYPEJ4W/5soxC
rNfzHkZBBxAgXNe7VIsOZDzEUh3QHmk9H+IGgmEDa9Vz6o/8efOafL4=
-- COPY UNTIL HERE --
*/
