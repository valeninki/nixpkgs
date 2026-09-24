{ pkgs, lib }:

let
  src = pkgs.fetchgit {
    url = "https://git.valentinus.dev/valeninki/steam-tui";
    rev = "0f08f632be6ca6d6ab84ec3692f339aac2987223";
    hash = "sha256-nb72iWr3SaBOgfcGEC/Tyh5i6aT5xuMO0ZQsl1ilL4U=";
  };
  steam-maintain = pkgs.buildGoModule {
    pname = "steam-maintain";
    version = "unstable-2026-09-24";
    inherit src;
    subPackages = [ "cmd/steam-maintain" ];
    vendorHash = null;
  };
in
pkgs.rustPlatform.buildRustPackage {
  pname = "steam-tui";
  version = "unstable-2026-09-24";

  inherit src;

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
      --prefix PATH : "${lib.makeBinPath [ pkgs.gamemode pkgs.mangohud steam-maintain pkgs.util-linux ]}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ pkgs.libsecret pkgs.openssl pkgs.dbus ]}"
  '';

  meta = with lib; {
    description = "Fast Steam terminal UI with safe Proton orchestration";
    homepage = "https://git.valentinus.dev/valeninki/steam-tui";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "steam-tui";
  };
}
