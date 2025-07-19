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
    (import ./reaper.nix)
    (import ./lsp-plugins.nix)
    (import ./vitalium.nix)
    (import ./nix-devShell.nix)
    #(import ./waybar.nix)
    #(import ./oi-grandad.nix)
    #(import ./ffmpeg.nix)
  ];
}
