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

  diabdat = fetchurl {
    name = "DIABDAT.MPQ";
    url = "https://pixeldrain.com/api/file/eK8CKhRD";
    hash = "sha256-wparJNXR0vbAXGeaJy4zy5EWdUx+iFAgYD2b2DMeUhU=";
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
    install -Dm444 "${diabdat}" "$out/share/diasurgical/devilution/DIABDAT.MPQ"
    ln -s DIABDAT.MPQ "$out/share/diasurgical/devilution/diabdat.mpq"
    wrapProgram $out/bin/devilutionx \
      --add-flags "--data-dir $out/share/diasurgical/devilution"
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
