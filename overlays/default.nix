{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import ./cdp.nix)
    (import ./cardinal.nix)
    (import ./plymouth-monoarch-theme.nix)
  ];
}
