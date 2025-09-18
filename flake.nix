{
  description = "Valen's Private Flake with custom packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.Parud = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./pkgs.nix
        ];
      };
    };
}

