{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  bzip2,
  cmake,
  pkg-config,
  gettext,
  libsodium,
  SDL2,
  SDL2_image,
  SDL_audiolib,
  simpleini,
  flac,
  fmt,
  libogg,
  libpng,
  libtiff,
  libwebp,
  makeWrapper,
  ninja,
  smpq,
  enableShareware ? true,
}:

let
  asio = fetchurl {
    url = "https://github.com/diasurgical/asio/archive/4bcf552fcea3e1ae555dde2ab33bc9fa6770da4d.tar.gz";
    hash = "sha256-AFBy5OFsAzxZsiI4DirIHh+VjFkdalEhN9OGqhC0Cvc=";
  };

  libmpq = fetchurl {
    url = "https://github.com/diasurgical/libmpq/archive/b78d66c6fee6a501cc9b95d8556a129c68841b05.tar.gz";
    hash = "sha256-NIzZwr6cBn38uKLWzW+Uet5QiOFUPB5dsf3FsS22ruo=";
  };

  libsmackerdec = fetchurl {
    url = "https://github.com/diasurgical/libsmackerdec/archive/91e732bb6953489077430572f43fc802bf2c75b2.tar.gz";
    hash = "sha256-5WXjfvGuT4hG2cnCS4YbxW/c4tek7OR95EjgCqkEi4c=";
  };

  libzt = fetchFromGitHub {
    owner = "diasurgical";
    repo = "libzt";
    fetchSubmodules = true;
    rev = "1a9d83b8c4c2bdcd7ea6d8ab1dd2771b16eb4e13";
    hash = "sha256-/A77ZM4s+br1hYa0OBdjXcWXUXYG+GiEYcW8VB+UJHo=";
  };

  spawnMpq = fetchurl {
    # The former raw/master URL is obsolete; upstream publishes this asset as release v5.
    url = "https://github.com/diasurgical/devilutionx-assets/releases/download/v5/spawn.mpq";
    hash = "sha256-ZEJ818G6kE6qLgAxwWprE20OzvmryIjF/4NEtFk1bjg=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "devilutionx";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "diasurgical";
    repo = "devilutionX";
    tag = finalAttrs.version;
    hash = "sha256-XfHpKERYZ+VCeWx95568FEEZ4UZg3Z4abA8mG4kHjy0=";
  };

  postPatch = ''
    substituteInPlace 3rdParty/asio/CMakeLists.txt --replace-fail "${asio.url}" "${asio}"
    substituteInPlace 3rdParty/libmpq/CMakeLists.txt --replace-fail "${libmpq.url}" "${libmpq}"
    substituteInPlace 3rdParty/libsmackerdec/CMakeLists.txt --replace-fail "${libsmackerdec.url}" "${libsmackerdec}"
    substituteInPlace 3rdParty/libzt/CMakeLists.txt \
      --replace-fail "GIT_REPOSITORY https://github.com/diasurgical/libzt.git" "" \
      --replace-fail "GIT_TAG ${libzt.rev}" "SOURCE_DIR ${libzt}"
  '';

  postInstall = ''
    ${lib.optionalString enableShareware ''
      install -Dm444 "${spawnMpq}" "$out/share/diasurgical/devilutionx/spawn.mpq"
    ''}
    wrapProgram $out/bin/devilutionx \
      --add-flags "--data-dir $out/share/diasurgical/devilutionx"
  '';

  cmakeFlags = [ "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" ];

  nativeBuildInputs = [
    cmake
    gettext
    makeWrapper
    ninja
    pkg-config
    smpq
  ];

  buildInputs = [
    bzip2
    flac
    fmt
    libogg
    libpng
    libsodium
    libtiff
    libwebp
    SDL2
    SDL2_image
    SDL_audiolib
    simpleini
  ];

  meta = with lib; {
    description = "Diablo build for modern operating systems";
    homepage = "https://github.com/diasurgical/devilutionX";
    license = licenses.sustainableUse;
    platforms = platforms.linux;
    mainProgram = "devilutionx";
  };
})
