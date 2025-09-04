self: super:
{
  jc303 = (super.stdenv.mkDerivation {
    name = "jc303";
    src = super.fetchzip {
      url = "https://github.com/midilab/jc303/releases/download/v0.12.2/jc303-0.12.2-linux_x64-plugins.zip";
      sha256 = "sha256-kamQjVU8xCjpo9As2ItyGEH5XSg56PsF9vz9LPSns7E=";
    };
    nativeBuildInputs = with super; [
      autoPatchelfHook
    ];

    buildInputs = with super; [
      alsa-lib
      freetype
      libGL
      (lib.getLib stdenv.cc.cc)
    ];

    installPhase = ''
      mkdir -p $out/lib/vst3
      cp -r $src/VST3/*.vst3 $out/lib/vst3
    '';
  });
}

