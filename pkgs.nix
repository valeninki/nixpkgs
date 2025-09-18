{ config, pkgs, lib, valenpkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    valenpkgs.topmem
    valenpkgs.zmem
  ];
}

