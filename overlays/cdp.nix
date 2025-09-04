self: super:

let
  cdp7 = super.fetchFromGitHub {
    owner = "ComposersDesktop";
    repo = "CDP7";
    rev = "master";
    hash = "sha256-pRXmbhb/szlMyLTNmdfHpXXZvrGndncvMzsIE4tDf+s=";
  };
  cdp8 = super.fetchFromGitHub {
    owner = "ComposersDesktop";
    repo = "CDP8";
    tag = "CDP8.0";
    hash = "sha256-/L0ncIcB0OardDykhNHwJ3ae09Sh4iNOQSZRgNV7ZPQ=";
  };
in
{
  cdp = super.clangStdenv.mkDerivation {
    name = "CDP 8.0.1";

    nativeBuildInputs = with super.pkgs; [
      pkg-config
      autoconf
      automake118x
      texinfoInteractive
      libtool
    ];

    buildInputs = with super.pkgs; [
      cmake
    ];

    buildCommand = ''
      export CFLAGS="-std=gnu89"
      
      tar fx ${cdp7}/libaaio/libaaio-0.3.1.tar.bz2
      cd libaaio-0.3.1

      substituteInPlace configure \
        --replace 'am__api_version="1.4"' 'am__api_version="1.18"'

      ./configure --prefix $out
      make install

      cd ..
      mkdir $out/src
      cp -r ${cdp8}/* $out/src
      chmod -R +w $out
      ln -s $out/include/* $out/src/dev/include
      sed -i '/option(USE_LOCAL_PORTAUDIO/c\option(USE_LOCAL_PORTAUDIO OFF)' $out/src/CMakeLists.txt
      sed -i 's/#*//' $out/src/dev/externals/CMakeLists.txt
      mkdir $out/src/build
      cd $out/src/build
      cmake -DAAIOLIB=$out/lib/libaaio.so -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ ..
      make
      mkdir $out/bin
      mv $out/src/NewRelease/* $out/bin
      rm -r $out/include $out/lib $out/man $out/src
    '';

  };
}
