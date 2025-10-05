{
  description = "Valen's Private Flake with custom packages";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = 
  { self, nixpkgs, flake-parts, ... }: {
    flakeModule = {
      options = {
        valenpkgs = flake-parts.lib.mkOption {
	  type = types.bool;
	  default = true;
	};
      };

      config = { valenpkgs, lib, pkgs, ... }: {
        imports = [
	  ./modules/flake
	];

	environment.systemPackages = lib.mkIfvalenpkgs [
	  pkgs.zmem
	  pkgs.topmem
	];
      };
    };
  };
}
