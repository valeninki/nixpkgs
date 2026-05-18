{ 
  self,
  lib, 
  ... 
}:

{

  perSystem =
    {
      config,
      self',
      inputs',
      pkgs,
      ...
    }:
    {
      packages = {
        topmem = pkgs.callPackage ./topmem { };
        zmem = pkgs.callPackage ./zmem { };
        agopengps = pkgs.callPackage ./agopengps {
		  wineWow64 = pkgs.wineWowPackages.stable;
		};
      };
    };

}
