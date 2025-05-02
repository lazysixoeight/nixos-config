self: super:
let
  logo = super.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/logo/nixos.svg.png";
    sha256 = "sha256-9+OfqfP5LmubdTcwBkS/AnOX4wZI2tKHLu5nhi43xcc=";
  };
in {
  plymouth-monoarch-theme = (super.stdenv.mkDerivation {
    name = "plymouth-monoarch-theme";
    src = super.fetchFromGitHub {
      owner = "farsil";
      repo = "monoarch";
      rev = "master";
      hash = "sha256-yc1LMrVUCPVsGIuKKUmoqFlCrVhhMhMOfOc9X4rjywo=";
    };
    nativeBuildInputs = with super; [
      ffmpeg
    ];
    installPhase = ''
      mkdir -p $out/share/plymouth/themes/monoarch
      cp -r * $out/share/plymouth/themes/monoarch
      find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;
      
      ffmpeg -i ${logo} -vf "lutrgb=r='if(eq(val,0),255,val)':g='if(eq(val,0),255,val)':b='if(eq(val,0),255,val)'" $out/share/plymouth/themes/monoarch/images/append.png
      mv $out/share/plymouth/themes/monoarch/images/append.png $out/share/plymouth/themes/monoarch/images/logo.png
    '';
  });
}

