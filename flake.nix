{
  description = "flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xlibre-overlay.url = "git+https://codeberg.org/takagemacoed/xlibre-overlay";
  };

  outputs = {self, nixpkgs, ...}@inputs:
  let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in
  {
    nixosConfigurations = {
      t480s = nixpkgs.lib.nixosSystem { # "nixos" is your hostname
        inherit system;
        specialArgs = { user = "lazy"; };
        modules = [
          ./hosts/t480s.nix
          inputs.home-manager.nixosModules.home-manager
          inputs.xlibre-overlay.nixosModules.overlay-xlibre-xserver
          inputs.xlibre-overlay.nixosModules.overlay-all-xlibre-drivers
        ];
        # ...
      };
    };
  };
}
