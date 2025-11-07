self: super:
{
  hatter-icon-theme = (super.stdenv.mkDerivation {
    name = "hatter-icon-theme";

    src = super.fetchFromGitHub {
      owner = "Mibea";
      repo = "Hatter";
      tag = "main";
      hash = "sha256-oBKDvCVHEjN6JT0r0G+VndzijEWU9L8AvDhHQTmw2E4=";
    };
    nativeBuildInputs = with super; [
      gtk3
      jdupes
    ];

    buildInputs = with super; [
      hicolor-icon-theme
    ];

    dontPatchELF = true;
    dontRewriteSymlinks = true;
    dontDropIconThemeCache = true;

    postPatch = ''
      patchShebangs install.sh
    '';

    installPhase = ''
      runHook preInstall

      $src/install.sh --dest $out/share/icons

      runHook postInstall
    '';
  });
}

