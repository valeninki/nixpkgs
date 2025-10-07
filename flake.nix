{
  description = "Valen's Private Flake with custom packages";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
    {
      systems = [
        "x86_64-linux"
	"aarch64-linux"
      ];
      perSystem = { pkgs, ... }: {
        packages.topmem = pkgs.callPackage ./modules/nixos/topmem {};
	packages.zmem = pkgs.callPackage ./modules/nixos/zmem {};

	nixosModules.valenpkgs = {
	  options = {};
	  config = {};
	};
      };
      nixosModules = {
        valenpkgs = self.perSystem.x86_64-linux.nixosModules.valenpkgs;
      }
    };
}
