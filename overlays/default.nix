{ nixpkgs, ...}:
{
  nixpkgs.overlays = [
    (import ./cdp.nix)
    (import ./sddm-breeze-wallpaper-hack.nix)
    #(import ./cardinal.nix)
    (import ./flameshot.nix)
    (import ./monokai-gtk-theme.nix)
    (import ./plymouth-monoarch-theme.nix)
    (import ./sddm-terminal.nix)
    (import ./xterminate.nix)
    (import ./kgtfo.nix)
    #(import ./sunvox.nix)
    (import ./renoise.nix)
    (import ./reaper.nix)
    (import ./neovim.nix)
    (import ./lsp-plugins.nix)
    (import ./distrho-ports.nix)
    (import ./nix-devShell.nix)
    #(import ./waybar.nix)
    (import ./oi-grandad.nix)
    (import ./jc303.nix)
    (import ./tal-plugins.nix)
    (import ./octasine.nix)
    (import ./soundthread.nix)
    #(import ./ffmpeg.nix)
  ];
}
