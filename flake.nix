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

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake {
      imports = [
        self.flakeModule
      ];
      systems = [ 
        "x86_64-linux" 
        "aarch64-linux" 
      ];
      perSystem = { config, pkgs, system, ... }: {
	nixosModules = {
	  valenpkgs = {config, pkgs, ...}: {
	    environment.systemPackages = with pkgs; [
	      self.packages.topmem
	      self.packages.zmem
	    ];
	  };
	};
      };
      flake = {

      };
    };
}
