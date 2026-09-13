{
  pkgs,
  lib,
}:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "psa-update";
  version = "1.0.12";

  src = pkgs.fetchFromGitHub {
    owner = "zeld";
    repo = pname;
    rev = version;
    hash = "sha256-wbgt0aIXmbUINteas48A1gOZF5EQlcjyCXa4OX6kDV8=";
  };

  cargoHash = "sha256-oq6V+gYcaui+WHwCDPTPycmX3JoA4jri/LM/vhVXH6g=";

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
