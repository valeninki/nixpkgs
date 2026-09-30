{ lib
, pkgs
, fetchurl
, stdenvNoCC
,
}:

stdenvNoCC.mkDerivation rec {
  pname = "prime-agent";
  version = "0.9.8";

  src = fetchurl {
    url = "https://github.com/PrimeIntellect-ai/prime-agent/releases/download/v${version}/prime-agent-${version}-linux-x64.tar.gz";
    hash = "sha256-g/sJEpv3jj5gJoISzXCTIWZZGxUYjKpwwbDvvMdiNeI=";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    tar -xzf $src
    mkdir -p $out/bin $out/lib/prime-agent
    cp -R . $out/lib/prime-agent
    chmod +x $out/lib/prime-agent/prime-agent
    cat > $out/bin/prime-agent <<EOF
    #!${stdenvNoCC.shell}
    exec $out/lib/prime-agent/prime-agent "\$@"
    EOF
    chmod +x $out/bin/prime-agent
    wrapProgram $out/bin/prime-agent \
      --prefix PATH : ${lib.makeBinPath [ pkgs.uv ]}
    runHook postInstall
  '';

  meta = {
    description = "Coding agent CLI with persistent sessions and a Python REPL kernel";
    homepage = "https://github.com/PrimeIntellect-ai/prime-agent";
    license = lib.licenses.mit;
    mainProgram = "prime-agent";
    maintainers = [{ name = "Valentinus"; }];
    platforms = [ "x86_64-linux" ];
  };
}
