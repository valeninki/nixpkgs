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

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
	"aarch64-linux"
      ];
      perSystem = {
        config,
	self',
	inputs',
	...
      }: 
      {
        imports = [
	  inputs.valenpkgs.flakeModule
	  ./modules/flake
	];

	environment.systemPackages = with pkgs; [
	  zmem
	  topmem
	];
      };


    };
}
