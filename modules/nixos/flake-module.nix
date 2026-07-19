{ self
, lib
, inputs
, ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages =
        { }
        // lib.optionalAttrs pkgs.stdenv.hostPlatform.isx86_64 {
          agopengps = pkgs.callPackage ./agopengps {
            wineWow64 = pkgs.wineWow64Packages.stable;
          };
          linux-rpi4-minimal =
            let
              crossPkgs = pkgs.pkgsCross.aarch64-multiplatform;
            in
            (import ./linux-rpi4-minimal) {
              inherit (crossPkgs) lib stdenv linux;
              linuxManualConfig = crossPkgs.linuxManualConfig;
            };
        }
        // {
          netui = inputs.netui.packages.${pkgs.stdenv.hostPlatform.system}.netui;
          topmem = pkgs.callPackage ./topmem { };
          zmem = pkgs.callPackage ./zmem { };
          psa-update = pkgs.callPackage ./psa-update { };
        };
    };

  flake.overlays.default = final: _prev: {
    valenpkgs.netui = self.packages.${final.stdenv.hostPlatform.system}.netui;
  };

  flake.nixosModules.default =
    { pkgs
    , lib
    , config
    , ...
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
        linux-rpi4-minimal = lib.mkEnableOption "Minimal headless RPi4 kernel (aarch64 only)";
      };

      config = lib.mkMerge [
        (lib.mkIf config.valenpkgs.topmem {
          environment.systemPackages = [ valenPkgs.topmem ];
        })
        (lib.mkIf config.valenpkgs.zmem {
          environment.systemPackages = [ valenPkgs.zmem ];
        })
        (lib.mkIf (config.valenpkgs.agopengps && pkgs.stdenv.hostPlatform.isx86_64) {
          environment.systemPackages = [ valenPkgs.agopengps ];
        })
        (lib.mkIf config.valenpkgs.psa-update {
          environment.systemPackages = [ valenPkgs.psa-update ];
        })
        (lib.mkIf (config.valenpkgs.linux-rpi4-minimal && pkgs.stdenv.hostPlatform.isAarch64) {
          boot.kernelPackages = pkgs.linuxPackagesFor valenPkgs.linux-rpi4-minimal;
        })
      ];
    };
}
