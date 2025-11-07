self: super:
{
  generic-drum = (super.stdenv.mkDerivation {
    name = "generic-drum";
    src = super.fetchurl {
      url = "https://github.com/ryukau/VSTPlugins/releases/download/UhhyouPlugins0.66.0/GenericDrum_0.1.4.zip";
      sha256 = "sha256-gLcgMgAqked1YlQRWoTQ27O6qJQbZdm7GDNhFxCl+3w=";
    };
    nativeBuildInputs = with super; [
      autoPatchelfHook
      unzip
    ];

    unpackPhase = ''
      unzip "$src" -x /
    '';

    buildInputs = with super; [
      (stdenv.cc.cc)
      (stdenv.cc.cc.lib)
      libxcb
      libxcb-cursor
      glib
      fontconfig
      cairo
      libxkbcommon
      pango
    ];

    installPhase = ''
      mkdir -p $out/lib/vst3
      cp -r *.vst3 $out/lib/vst3
    '';
  });
}

