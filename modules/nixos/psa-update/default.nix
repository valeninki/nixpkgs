{
  pkgs,
  lib,
}:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "psa-update";
  version = "1.0.11";

  src = pkgs.fetchFromGitHub {
    owner = "zeld";
    repo = pname;
    rev = version;
    hash = "sha256-1cw91iGtNBILOihC6VNUFSsRVsaxJE0hGkO86L9EKTk=";
  };

  cargoHash = "sha256-+LNVOuyDoEZjffydY7ZjzMBCq3+wvSMYdbWL3qMBEJk=";

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
