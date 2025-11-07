self: super:

let

tal-drum = super.fetchurl { 
  url = "https://www.dropbox.com/scl/fo/tvhhu7rgquds4x3ydwz1x/AGjQ2ZQho4g9fbX1hKuLz-w?rlkey=ea9d9076mu3k32rj1bjwy8b0h&st=umb5pubb&dl=1";
  hash = "sha256-ljGFaYntOePZgbhysjXq0KO4efBLi6a3IwOIbb31ghQ=";
};

in {
  tal-plugins = (super.stdenv.mkDerivation { 
    name = "tal-plugins";
    src = super.fetchurl { # TAL-DAC
      url = "https://www.dropbox.com/scl/fo/szpd5dcb3js3506cznfz2/AN-0qYEj-113X2yPEab5rf0?rlkey=1iab3htzr10bt8ujcariwi8ks&st=3a2bbxmm&dl=1";
      hash = "sha256-niSbjT7FaX90AA1+PJ0RUMuEsBFa8seOGDSSsjDLMlU=";
    };
    
    nativeBuildInputs = [ super.autoPatchelfHook super.unzip ];
    buildInputs = with super; [
      (super.stdenv.cc.cc)
      (super.stdenv.cc.cc.lib)
      alsa-lib
      fontconfig
      freetype
      libGL
    ];

    unpackPhase = ''
      unzip "$src" -x / "ReadmeLinux.txt"
      unzip "${tal-drum}" -x / "ReadmeLinux.txt"
    '';

    installPhase = ''
      mkdir -p $out/lib/{vst3,vst,clap}
      cp -r *.vst3 $out/lib/vst3/
      cp *.so $out/lib/vst/
      cp *.clap $out/lib/clap/
    '';
  });
}


# Lucky you! (TAL-Sampler key also works for TAL-DAC)
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
