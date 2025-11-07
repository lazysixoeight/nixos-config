self: super:
{
  fluida-lv2 = (super.stdenv.mkDerivation {
    name = "fluida-lv2";
    src = super.fetchurl {
      url = "https://github.com/brummer10/Fluida.lv2/releases/download/v0.9.5/Fluida.lv2-v0.9.5-linux-x86_64.tar.xz";
      sha256 = "sha256-IMs2SiFdf+vkXmzTtD5GSeWT+SrrXtamnNlgCud2vW8=";
    };
    nativeBuildInputs = with super; [
      autoPatchelfHook
    ];

    buildInputs = with super; [
      glib
      xorg.libXext
      xorg.libX11
      xorg.libXrender
    ];

    installPhase = ''
      tar -xf $src
      mkdir -p $out/lib/lv2
      cp -r *.lv2 $out/lib/lv2
    '';
  });
}

