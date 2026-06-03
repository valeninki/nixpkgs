{
  self,
  lib,
  inputs,
  ...
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
            crossPkgs.callPackage ./linux-rpi4-minimal {
              rpiKernel = crossPkgs.callPackage "${inputs.nixos-hardware}/raspberry-pi/common/kernel.nix" {
                rpiVersion = 4;
              };
            };
        }
        // {
          topmem = pkgs.callPackage ./topmem { };
          zmem = pkgs.callPackage ./zmem { };
          psa-update = pkgs.callPackage ./psa-update { };
        };
    };

  flake.nixosModules.default =
    {
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
