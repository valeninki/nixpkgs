{
  pkgs,
}:

pkgs.stdenv.mkDerivation {
  pname = "topmem";
  version = "unstable-2025-05-30";

  src = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/CachyOS/CachyOS-Settings/6b32afb/usr/bin/topmem";
    hash = "sha256-kcFZs1+JJ1hGaV9seczFWcM/gXABL/psMLa1nzdID/Y=";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];

  buildInputs = [
    (pkgs.lua5_4.withPackages (ps: with ps; [ luv ]))
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/topmem
    chmod +x $out/bin/topmem
    wrapProgram $out/bin/topmem \
      --prefix PATH : ${pkgs.lib.makeBinPath [ (pkgs.lua5_4.withPackages (ps: with ps; [ luv ])) ]}
  '';

  meta = with pkgs.lib; {
    description = "Memory monitor from CachyOS";
    homepage = "https://github.com/CachyOS/CachyOS-Settings";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "topmem";
  };
}
