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
      packages.${system} = {
        topmem = pkgs.callPackage ./pkgs/applications/system/topmem {};
        zmem   = pkgs.callPackage ./pkgs/applications/system/zmem {};
      };
    };
}
