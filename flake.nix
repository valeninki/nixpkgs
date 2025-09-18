{
  description = "Valen's Private Flake for Custom Packages.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, ... }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    ${system} = rec {
      topmem = pkgs.callPackage ./pkgs/applications/system/topmem/default.nix {};
      zmem = pkgs.callPackage ./pkgs/applications/system/zmem/default.nix {};
    };
  };
}

