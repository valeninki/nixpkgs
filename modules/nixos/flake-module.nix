{
  self,
  lib,
  ...
}: {
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        topmem = pkgs.callPackage ./topmem { };
        zmem = pkgs.callPackage ./zmem { };
        agopengps = pkgs.callPackage ./agopengps {
          wineWow64 = pkgs.wineWowPackages.stable;
        };
        psa-update = pkgs.callPackage ./psa-update { };
      };
    };

  flake.nixosModules.default = {
    pkgs,
    lib,
    config,
    ...
  }:
  let
    valenPkgs = self.packages.${pkgs.system};
  in
  {
    options.valenpkgs = {
      topmem = lib.mkEnableOption "topmem - CachyOS memory monitor";
      zmem = lib.mkEnableOption "zmem - Rust memory monitor";
      agopengps = lib.mkEnableOption "AgOpenGPS - agricultural guidance";
      psa-update = lib.mkEnableOption "psa-update - Stellantis infotainment update tool";
    };

    config = lib.mkMerge [
      (lib.mkIf config.valenpkgs.topmem {
        environment.systemPackages = [ valenPkgs.topmem ];
      })
      (lib.mkIf config.valenpkgs.zmem {
        environment.systemPackages = [ valenPkgs.zmem ];
      })
      (lib.mkIf config.valenpkgs.agopengps {
        environment.systemPackages = [ valenPkgs.agopengps ];
      })
      (lib.mkIf config.valenpkgs.psa-update {
        environment.systemPackages = [ valenPkgs.psa-update ];
      })
    ];
  };
}
