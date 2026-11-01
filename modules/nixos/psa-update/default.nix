{
  pkgs,
  lib,
}:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "psa-update";
  version = "1.0.13";

  src = pkgs.fetchFromGitHub {
    owner = "zeld";
    repo = pname;
    rev = version;
    hash = "sha256-eKCV5ft4cdyX/yDOyMpI2nIf9M8WF9yaQ46nH2zUwSE=";
  };

  cargoHash = "sha256-0Hii3ndJW9S3cWZDboJ12cydXWeQ0RSkpneC4Y6YLNo=";

  nativeBuildInputs = [ pkgs.pkg-config ];

  buildInputs = [ pkgs.openssl ];

  meta = with lib; {
    description = "CLI alternative to Stellantis (Peugeot/Citroën/DS/Opel) update applications for car infotainment systems";
    homepage = "https://github.com/zeld/psa-update";
    license = licenses.unlicense;
    platforms = platforms.linux;
    mainProgram = "psa-update";
    maintainers = [ { name = "Kerem"; } ];
  };
}
