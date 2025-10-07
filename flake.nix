{
  description = "Valen's Private Flake with custom packages";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };
    unixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "unixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./modules/flake
      ];
      systems = [ 
        "x86_64-linux" 
        "aarch64-linux" 
      ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages = {
	  topmem = pkgs.callPackage./modules/flake/topmem {};
	  zmem = pkgs.callPackage./modules/flake/topmem {};
	};

	nixosModules = {
	  valenpkgs = {config, pkgs, ...}: {

	    environment.systemPackages = [
	      self'.packages.topmem
	      self'.packages.zmem
	    ];
	  };
	};
      };
      flake = {

      };
    };
}
