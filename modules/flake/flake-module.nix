{ config, pkgs, ... }:

{
  packages = {
    topmem = pkgs.callPackage ./topmem/default.nix {};
    zmem = pkgs.callPackage ./zmem/default.nix {};
  };

  nixosModules = {
    valenpkgs = {
      config, pkgs, ... }: {
        environment.systemPackages = with pkgs; [
          self.packages.topmem
          self.packages.zmem
        ];
      };
  };
}

