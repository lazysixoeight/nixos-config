{
  description = "flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
        modules = [
          ./hosts/t480s.nix
          inputs.home-manager.nixosModules.home-manager
        ];
        # ...
      };
    };
  };
}
