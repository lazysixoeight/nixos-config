self: super:
let
  dx7skin = super.fetchurl {
    url = "https://drive.usercontent.google.com/download?id=1zJr1IvJ7K2IS0SXyad6OLkypG4stuTge&export=download"; # Replace with direct link
    hash = "sha256-Y9G3dpdMAbYayPotorxhlMFSopZEQn00UxY9fyMK90Q="; # Replace with actual hash
  };
in
{
  oxefmsynth = super.oxefmsynth.overrideAttrs (oldAttrs: { 
    buildInputs = [ super.unzip super.xorg.libX11 ];

    installPhase = ''
      mkdir -p $out/lib/vst
      install -Dm644 oxevst64.so -t $out/lib/vst
      
      tmpdir=$(mktemp -d)
      unzip ${dx7skin} -d "$tmpdir"
      cp -r "$tmpdir"/skin $out/lib/vst/skin
    '';
  });
}
