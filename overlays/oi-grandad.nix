self: super:
{
  oi-grandad = (super.stdenv.mkDerivation {
    name = "oi-grandad";
    src = super.fetchurl {
      url = "https://github.com/publicsamples/Oi-Grandad/releases/download/2.0.1/oigrandadV2.vst3.Linux.tar.xz";
      sha256 = "sha256-pQqOjEoCKB5wihtWxGMVKwoumWfMo46hBf6EF9e6aQ8=";
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
      tar -xf $src
      mkdir -p $out/lib/vst3
      cp -r *.vst3 $out/lib/vst3
    '';
  });
}

