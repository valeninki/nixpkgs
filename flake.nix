{
  description = "Valen's Private Flake for Custom Packages.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      valenpkgs = {
        topmem = pkgs.callPackage ./pkgs/applications/system/topmem {};
        zmem   = pkgs.callPackage ./pkgs/applications/system/zmem {};
      };
    in
    {
      nixosConfigurations.Parud = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          (import ./pkgs.nix { inherit config pkgs lib valenpkgs; })
        ];
      };
    };
}

