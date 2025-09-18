{
  description = "Valenpkgs's Flakes.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = {self, nixpkgs, ... }@inputs:
  let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    valenpkgs = import ./pkgs;
  in
  {
    nixosConfigurations.valenpkgs = lib.nixosSystem {
      inherit system;
      modules = [
       ./pkgs.nix 
      ];
      specialArgs = {
        inherit valenpkgs;
      };
    };    
  };
}
