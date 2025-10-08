{ self, lib, ...}: {
  
  perSystem = { config, self', inputs', pkgs, ... }: {
    packages = {
      topmem = pkgs.callPackage ./topmem {};
      zmem = pkgs.callPackage ./zmem {};
    };
  };
  flake = {
    nixosModules.valenpkgs = { pkgs, ... }: {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.topmem
	self.packages.${pkgs.stdenv.hostPlatform.system}.zmem
      ];
    };
  };
}
