self: super:
{
  xterminate = super.writeShellScriptBin "xterm" ''
    alacritty $@
  '';
}

