{
  description = "Valen's Private Flake with custom packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    netui = {
      url = "git+https://git.valentinus.dev/valeninki/netui.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./modules/nixos/flake-module.nix
      ];
      systems = [
        "x86_64-linux"
      ];
      perSystem =
        { pkgs, self', ... }:
        {
          formatter = pkgs.nixpkgs-fmt;

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              nixpkgs-fmt
              statix
              deadnix
            ];
          };

          checks = {
            inherit (self'.packages) topmem devilutionx psa-update;
          }
          // pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isx86_64 {
            inherit (self'.packages) agopengps linux-rpi4-minimal;
          };
        };
    };
}
