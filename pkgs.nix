{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    (pkgs.callPackage ./pkgs/applications/system/topmem {})
    (pkgs.callPackage ./pkgs/applications/system/zmem {})
  ];
}

