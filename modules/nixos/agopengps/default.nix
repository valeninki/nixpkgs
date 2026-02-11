{
  lib,
  stdenv,
  fetchzip,
  wineWow64,
  makeWrapper,
  writeShellScriptBin,
}:

stdenv.mkDerivation {
  pname = "AgOpenGPS";
  version = "6.8.1";

  src = fetchzip {
    url = "https://github.com/AgOpenGPS-Official/AgOpenGPS/releases/download/${version}/AgOpenGPS_${version}.zip";
    hash = "sha256:c36b6c8d7db43bd1084425cfec0e2ec553544b384448e00c7d59bf7624212d18";
    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    	  runHook preInstall

    	  mkdir -p $out/share/agopengps
    	  cp -r * $out/share/agopengps
    	  mkdir -p $out/bin

    	  makeWrapper ${wineWow64}/bin/wine $out/bin/agopengps \
    	    --run "export WINEPREFIX=$HOME/.local/share/agopengps-prefix" \
    		--run "mkdir -p \$WINEPREFIX" \
    		--add-flags "$out/share/agopengps/AgOpenGPS.exe"
          
    	  runHook postInstall
  '';

  meta = with lib; {
    description = "AgOpenGPS - Open Source Agricultural Guidance";
    homepage = "https://github.com/AgOpenGPS-Offical/AgOpenGPS";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ "Kerem" ];
  };
}
