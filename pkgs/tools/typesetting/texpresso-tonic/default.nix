/*
  This file provides the `tectonic-unwrapped` package. On the other hand,
  the `tectonic` package is defined in `./wrapper.nix`, by wrapping
  - [`tectonic-unwrapped`](./default.nix) i.e. this package, and
  - [`biber-for-tectonic`](./biber.nix),
    which provides a compatible version of `biber`.
*/

{ lib
, stdenv
, fetchFromGitHub
, runCommand
, fetchurl
, rustPlatform
, darwin
, fontconfig
, harfbuzz
, openssl
, pkg-config
, icu
}:

rustPlatform.buildRustPackage rec {
  pname = "texpresso-tonic";
  version = "08d4ae8632ef0da349595310d87ac01e70f2c6ae";

  cargoLock.lockFile = ./Cargo.lock;

  src = fetchFromGitHub {
    owner = "let-def";
    repo = "texpresso";
    rev = "08d4ae8632ef0da349595310d87ac01e70f2c6ae";
    fetchSubmodules = true;
    sha256 = "sha256-vgZIjYMpS7PQoaK/UWJhoVhHW4wR3EmeQF7LKBAbQ/w=";
  };

  # src =
  #   let
  #     source = fetchFromGitHub {
  #       owner = "let-def";
  #       repo = "texpresso";
  #       rev = "08d4ae8632ef0da349595310d87ac01e70f2c6ae";
  #       fetchSubmodules = true;
  #       sha256 = "sha256-vgZIjYMpS7PQoaK/UWJhoVhHW4wR3EmeQF7LKBAbQ/w=";
  #     } + "/tectonic/";
  #   in
  #   runCommand "source" {} ''
  #     mkdir -p $out
  #     # cp -r ${source} $out
  #     # chmod +w $out
  #     cp ${./Cargo.lock} $out/Cargo.lock
  #   '';

  # cargoLock = fetchFromGitHub {
  #   owner = "let-def";
  #   repo = "texpresso";
  #   rev = "08d4ae8632ef0da349595310d87ac01e70f2c6ae";
  #   fetchSubmodules = true;
  #   sha256 = "sha256-vgZIjYMpS7PQoaK/UWJhoVhHW4wR3EmeQF7LKBAbQ/w=";
  # } + "/tectonic/Cargo.lock";

  # cargoLock = fetchurl {
  #  url = "https://github.com/let-def/tectonic/blob/a6d47e45cd610b271a1428898c76722e26653667/Cargo.lock";
  # };
  # cargoHash = "sha256-3Twmvsu/aRWRLIfx76ulkMkRk5tXSEIGTArJuY5bsiQ=";

  buildPhase = ''
    make texpresso-tonic
  '';

  postPatch = ''
  ln -s ${./Cargo.lock} Cargo.lock
'';

  installPhase = ''
    mkdir -p $out/bin
    cp build/texpresso-tonic $out/bin/texpresso-tonic
  '';

  cargoSha256 = "";

  nativeBuildInputs = [ pkg-config ];

  buildFeatures = [ "external-harfbuzz" ];

  buildInputs = [ icu fontconfig harfbuzz openssl ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ ApplicationServices Cocoa Foundation ]);

  doCheck = false;

  meta = with lib; {
    description = "Helper for TeXpresso, needs to be built seperately";
    homepage = "https://github.com/let-def/texpresso";
    license = with licenses; [ mit ];
    mainProgram = "texpresso";
    maintainers = with maintainers; [ corlie rall ];
  };
}
