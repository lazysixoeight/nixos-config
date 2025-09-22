self: super:
{
  octasine = (super.stdenv.mkDerivation {
    name = "octasine";
    src = super.fetchzip {
      url = "https://github.com/greatest-ape/OctaSine/releases/download/v0.9.1/OctaSine-v0.9.1-Ubuntu-20_04.zip";
      sha256 = "sha256-Od6MPd+PvHD/pQ1jC2Ioi2NcjDfdmJxctGSKGtz2AI0=";
    };
    nativeBuildInputs = with super; [
      autoPatchelfHook
    ];

    buildInputs = with super; [
      xorg.libX11
      xorg.libXcursor
      xorg.libxcb
      xorg.xcbutilwm
      libGL
      libgcc
    ];

    installPhase = ''
      mkdir -p $out/lib/vst
      mkdir -p $out/lib/clap
      cp -r $src/VST2/*.so $out/lib/vst
      cp -r $src/CLAP/*.clap $out/lib/clap
    '';
  });
}

