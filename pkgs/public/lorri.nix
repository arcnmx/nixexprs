{ lib, stdenv, fetchFromGitHub, makeWrapper, rustPlatform, coreutils, nix, direnv, which, darwin }: rustPlatform.buildRustPackage rec {
  src = fetchFromGitHub {
    owner = "target";
    repo = "lorri";
    #branch = "rolling-release";
    rev = "094a903d19eb652a79ad6e7db6ad1ee9ad78d26c";
    sha256 = "0y9y7r16ki74fn0xavjva129vwdhqi3djnqbqjwjkn045i4z78c8";
  };
  pname = "lorri";
  version = "rolling-release";
  cargoSha256 = if lib.versionOlder lib.version "19.09pre"
    then "04v9k81rvnv3n3n5s1jwqxgq1sw83iim322ki28q1qp5m5z7canv"
    else "0lx4r05hf3snby5mky7drbnp006dzsg9ypsi4ni5wfl0hffx3a8g";
  COREUTILS = coreutils;
  BUILD_REV_COUNT = 1;

  buildInputs = [ nix direnv which ] ++
    lib.optionals stdenv.isDarwin [
      darwin.cf-private
      darwin.Security
      darwin.apple_sdk.frameworks.CoreServices
    ];

  nativeBuildInputs = [ makeWrapper ];
  wrapperPath = lib.makeBinPath [ nix direnv ];

  postInstall = ''
    wrapProgram $out/bin/$pname --prefix PATH : $wrapperPath
  '';

  doCheck = false;
}
