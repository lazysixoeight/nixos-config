self: super:
{
  tal-sampler = (super.stdenv.mkDerivation { 
    name = "tal-sampler";
    src = super.fetchurl {
      url = "https://uc5da3841cc1dc41678738ee40b7.dl.dropboxusercontent.com/zip_download_get/CUh0uKQ61AyUyKcecscAW-lvCL_xG3zxxENbcAVba-l5sqg-u1cqV435pVGlu5nLEagcVsaXo5wknO2WVTsOxorztZ9HsIk0Ng-6Ro1UNGY-4Q"; # Replace with direct link
      hash = "sha256-ebYYONcoYX/tqWga+KqECBL2L15LOw9NngX9Mnt4CAY="; # Replace with actual hash
    };
    
    nativeBuildInputs = [ super.autoPatchelfHook super.unzip ];
    buildInputs = with super; [
      (super.stdenv.cc.cc)
      (super.stdenv.cc.cc.lib)
      alsa-lib
      fontconfig
      freetype
    ];

    unpackPhase = ''
      unzip $src -x /
    '';

    installPhase = ''
      mkdir -p $out/lib/{vst3,vst,clap}
      cp -r *.vst3 $out/lib/vst3/
      cp *.so $out/lib/vst/
      cp *.clap $out/lib/clap/
    '';
  });
}

# Lucky you!

#-- COPY LICENSE KEY FROM HERE --
#Product: TAL-Sampler
#Licensee: 
#D8cHy3Jjx7Lcxu8mw2yhrs9/anOwt3goEJ6N+LdFKs79WUiTTf8FY7+2Rp
#ip6twgdlKVKJG05KA/Em+5WHa8+jBabrcnQTYeBB7QNwGIIS4R9UVV8Xd7
#S23C9sem7HLS5y5ExmK8MyWUnrFEBhXLJMlf4g8ZB2MEje1X3qGx6hE=
#-- COPY UNTIL HERE --
