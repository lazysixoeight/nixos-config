self: super:
{
  kgtfo = super.writeShellScriptBin "kgx" ''
    alacritty $@
  '';
}

