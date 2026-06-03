{
  pkgs,
}:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "zmem";
  version = "unstable-2025-05-30";

  src = pkgs.fetchFromGitHub {
    owner = "xeome";
    repo = pname;
    rev = "140d37e";
    hash = "sha256-qn/xfw/p2b6A2pyiTaxS7Nlu5Gk8D7qTDDQfJ+3BzDQ=";
  };

  cargoHash = "sha256-pkBjVybga4yUmy8jpUfYi9i8eeRU2sIFEweDZLffP4o=";

  meta = with pkgs.lib; {
    description = "Advanced linux memory monitoring";
    homepage = "https://github.com/xeome/zmem";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "zmem";
  };
}
