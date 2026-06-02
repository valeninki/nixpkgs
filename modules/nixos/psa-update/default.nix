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
    sha256 = "0f998jzyig2338hls95iqrb12aqmai9yjhi8785i4d5d47b3vk6m";
  };

  cargoHash = "sha256-+LNVOuyDoEZjffydY7ZjzMBCq3+wvSMYdbWL3qMBEJk=";

  nativeBuildInputs = [ pkgs.pkg-config ];

  buildInputs = [ pkgs.openssl ];

  meta = with lib; {
    description = "CLI alternative to Stellantis (Peugeot/Citroën/DS/Opel) update applications for car infotainment systems";
    homepage = "https://github.com/zeld/psa-update";
    license = licenses.unlicense;
    maintainers = [ "Kerem" ];
    mainProgram = "psa-update";
  };
}
