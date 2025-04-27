{ config, pkgs, ... }:
{
  imports = [
    ./cdp.nix
  ];
  nixpkgs.overlays = [
    (import ./cdp.nix)
  ];
}
