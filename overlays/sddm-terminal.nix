self: super:
let
  user-cfg = (super.formats.ini { }).generate "theme.conf.user" { };
in {
  sddm-terminal = (super.stdenv.mkDerivation rec {
    pname = "sddm-terminal";
    version = "0.2";
    src = super.fetchFromGitHub {
      owner = "GistOfSpirit";
      repo = "TerminalStyleLogin";
      tag = "v${version}";
      hash = "sha256-BP/NUx1XCmOWKLuqMcG8RV68pnAgNFqMgJYArP472Vk=";
    };
    buildPhase = ''
      patchShebangs scripts/build.sh
      ./scripts/build.sh
    '';

    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -r build $out/share/sddm/themes/terminal
      ln -sf ${user-cfg} $out/share/sddm/themes/terminal/theme.conf.user
    '';
  });
}

