{ pkgs, lib }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "steam-tui";
  version = "unstable-2026-09-16";

  src = pkgs.fetchgit {
    url = "https://git.valentinus.dev/valeninki/steam-tui";
    rev = "5b18436df48aa0eab6abe62727270dd3737f209f";
    hash = "sha256-EYbA5VRyiGK98X1KYs1lv1tRPbQHo/41lsqpFT65h1M=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  nativeBuildInputs = [
    pkgs.pkg-config
    pkgs.rustPlatform.cargoSetupHook
    pkgs.makeWrapper
  ];

  nativeCheckInputs = [ pkgs.util-linux ];

  buildInputs = [
    pkgs.openssl
    pkgs.dbus
    pkgs.libsecret
  ];

  cargoBuildFlags = [ "--package" "steam-tui" ];

  postInstall = ''
    wrapProgram "$out/bin/steam-tui" \
      --prefix PATH : "${lib.makeBinPath [ pkgs.gamemode pkgs.mangohud ]}"
  '';

  meta = with lib; {
    description = "Fast Steam terminal UI with safe Proton orchestration";
    homepage = "https://git.valentinus.dev/valeninki/steam-tui";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "steam-tui";
  };
}
