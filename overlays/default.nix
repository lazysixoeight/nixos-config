{ nixpkgs, ...}:
{
  nixpkgs.overlays = [
    #(import ./cdp.nix)
    #(import ./cardinal.nix)
    (import ./flameshot.nix)
    (import ./monokai-gtk-theme.nix)
    (import ./plymouth-monoarch-theme.nix)
    (import ./xterminate.nix)
    #(import ./sunvox.nix)
    (import ./renoise.nix)
    #(import ./oi-grandad.nix)
    #(import ./ffmpeg.nix)
  ];
}
