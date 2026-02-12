{
  lib,
  stdenv,
  fetchurl,
  p7zip,
  wineWow64,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "AgOpenGPS";
  version = "6.8.1";

  src = fetchurl {
    url = "https://github.com/AgOpenGPS-Official/AgOpenGPS/releases/download/${version}/AgOpenGPS_${version}.zip";
    hash = "sha256-w2tsjX20O9EIRCXP7A4uxVNUSzhESOAMfVm/diQhLRg=";
  };
  
  dontUnpack = true;
  nativeBuildInputs = [ p7zip makeWrapper ];

  installPhase = ''
    	  runHook preInstall

		  export HOME=$TMPDIR
    	  
		  mkdir -p source_temp
		  
		  7z x $src -osource_temp -y

		  mkdir -p $out/share/agopengps

		  if [ -d "source_temp/Source" ]; then
            cp -r source_temp/Source/* $out/share/agopengps/
		  elif [ -d "source_temp/source" ]; then
		    cp -r source_temp/source/* $out/share/agopengps/
		  else
		    cp -r source_temp/* $out/share/agopengps/
          fi

    	  mkdir -p $out/bin

    	  makeWrapper ${wineWow64}/bin/wine $out/bin/agopengps \
    	    --run 'export WINEPREFIX="$HOME/.local/share/agopengps-prefix"' \
    		--run 'mkdir -p "$WINEPREFIX"' \
    		--add-flags "$out/share/agopengps/AgOpenGPS.exe"
          
    	  runHook postInstall
  '';

  meta = with lib; {
    description = "AgOpenGPS - Open Source Agricultural Guidance";
    homepage = "https://github.com/AgOpenGPS-Offical/AgOpenGPS";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
	mainProgram = "agopengps";
    maintainers = with maintainers; [ "Kerem" ];
  };
}
