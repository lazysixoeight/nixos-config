self: super:
{
  kgtfo = super.writeShellScriptBin "kgx" ''
    kitty $@
  '';
}

