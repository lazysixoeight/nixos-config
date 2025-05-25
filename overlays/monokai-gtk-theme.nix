self: super:
{
  monokai-gtk-theme = (super.stdenv.mkDerivation {
    name = "monokai-gtk-theme";
    
    src = super.fetchFromGitHub {
      owner = "mitch-kyle";
      repo = "monokai-gtk";
      rev = "master";
      sha256 = "sha256-fJqws14h9WcfqKXA3aIiEGaXSHRQjR4cCil6gfkBums=";
    };

    propagatedUserEnvPkgs = [ super.gtk-engine-murrine ];
    dontBuild = true;

    installPhase = ''
      install -dm 755 "$out/share/themes/monokai"
      cp -r --no-preserve='ownership' $src/* $out/share/themes/monokai/
    '';
  });
}


