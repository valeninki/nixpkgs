{
  lib,
  fetchurl,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "prime-agent";
  version = "0.9.6";

  src = fetchurl {
    url = "https://github.com/PrimeIntellect-ai/prime-agent/releases/download/v0.9.6/prime-agent-0.9.6-linux-x64.tar.gz";
    hash = "sha256-LqeBKjELwWrgyZ//e8odHkZQd684zxA6rRZ/EMISmAE=";
  };

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
    runHook postInstall
  '';

  meta = {
    description = "Coding agent CLI with persistent sessions and a Python REPL kernel";
    homepage = "https://github.com/PrimeIntellect-ai/prime-agent";
    license = lib.licenses.mit;
    mainProgram = "prime-agent";
    maintainers = [ { name = "Valentinus"; } ];
    platforms = [ "x86_64-linux" ];
  };
}
