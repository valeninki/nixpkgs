{ self, lib, ...}: {
  
  perSystem = { config, self', inputs', pkgs, ... }: {
    packages.topmem = pkgs.callPackage ./topmem {};
    packages.zmem = pkgs.callPackage ./zmem {};
  };
  flake = {
    nixosModules.valenpkgs = { pkgs, ... }: {
      environment.systemPackages = [
        self.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.valenpkgs
      ];
    };
  };
}
