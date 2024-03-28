{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
, fontconfig
, harfbuzz
, openssl
, pkg-config
, makeBinaryWrapper
, icu
, mupdf
, re2c
, SDL2
, openjpeg
, libjpeg
, libpng
, freetype
, gumbo
, jbig2dec
, leptonica
, tesseract
, mujs
}:

stdenv.mkDerivation rec {
  pname = "texpresso";
  version = "08d4ae8632ef0da349595310d87ac01e70f2c6ae";

  src = fetchFromGitHub {
    owner = "let-def";
    repo = "texpresso";
    rev = "08d4ae8632ef0da349595310d87ac01e70f2c6ae";
    fetchSubmodules = true;
    sha256 = "sha256-vgZIjYMpS7PQoaK/UWJhoVhHW4wR3EmeQF7LKBAbQ/w=";
  };

  #cargoHash = "sha256-1WjZbmZFPB1+QYpjqq5Y+fDkMZNmWJYIxmMFWg7Tiac=";
  #cargoHash = "";

  buildPhase = "make texpresso";

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp build/texpresso $out/bin/texpresso
  '';
  # dontInstall = true;


  nativeBuildInputs = [ pkg-config makeBinaryWrapper ];

  buildInputs = [ icu fontconfig harfbuzz openssl mupdf re2c SDL2 openjpeg libjpeg libpng freetype gumbo jbig2dec leptonica tesseract mujs]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ ApplicationServices Cocoa Foundation ]);

  # workaround for https://github.com/NixOS/nixpkgs/issues/166205
  NIX_LDFLAGS = lib.optionalString (stdenv.cc.isClang && stdenv.cc.libcxx != null) " -l${stdenv.cc.libcxx.cxxabi.libName}";

  # postInstall = lib.optionalString stdenv.isLinux ''
  #   substituteInPlace dist/appimage/tectonic.desktop \
  #     --replace Exec=tectonic Exec=$out/bin/tectonic
  #   install -D dist/appimage/tectonic.desktop -t $out/share/applications/
  #   install -D dist/appimage/tectonic.svg -t $out/share/icons/hicolor/scalable/apps/

  #   ln -s $out/bin/tectonic $out/bin/nextonic
  # '';

  doCheck = true;

  meta = with lib; {
    description = "Live rendering and error reporting for LaTeX";
    homepage = "https://github.com/let-def/texpresso";
    license = with licenses; [ mit ];
    mainProgram = "texpresso";
    maintainers = with maintainers; [ corlie rall ];
  };
}
