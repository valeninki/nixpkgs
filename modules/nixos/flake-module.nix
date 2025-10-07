{ self, lib, ...}: {
  
  perSystem = { config, self', inputs', pkgs, ... }: {
    packages.topmem = pkgs.callPackage ./topmem {};
    packages.zmem = pkgs.callPackage ./zmem {};
    valenpkgs = self.outputs.packages.${pkgs.stdenv.hostPlatform.system}.valenpkgs;
  };
  flake = {
    nixosModules.valenpkgs = { pkgs, ... }: {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.valenpkgs
      ];
    };
  };
}
