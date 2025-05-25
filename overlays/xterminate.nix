self: super:
{
  xterminate = super.writeShellScriptBin "xterm" ''
    # Your desired terminal
    foot $@
  '';
}
