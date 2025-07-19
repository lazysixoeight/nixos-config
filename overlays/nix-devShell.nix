self: super: {
  nix-devShell = super.writeShellScriptBin "nix-devShell" ''
    cat > flake.nix <<'EOF'
{
  description = "flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/release-25.05";

  outputs = { nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    devShells.''${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        #fastfetch
      ];
      shellHook = "echo \"Entering devShell\"\nfish";
    };
  };
}
EOF
  '';
}

