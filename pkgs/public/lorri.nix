{ lib, stdenv, fetchFromGitHub, rustPlatform, coreutils, nix, direnv, which, darwin }: rustPlatform.buildRustPackage {
  src = fetchFromGitHub {
    owner = "target";
    repo = "lorri";
    #branch = "rolling-release";
    rev = "094a903d19eb652a79ad6e7db6ad1ee9ad78d26c";
    sha256 = "0y9y7r16ki74fn0xavjva129vwdhqi3djnqbqjwjkn045i4z78c8";
  };
  name = "lorri";
  cargoSha256 = "0lx4r05hf3snby5mky7drbnp006dzsg9ypsi4ni5wfl0hffx3a8g";
  COREUTILS = coreutils;
  BUILD_REV_COUNT = 1;

  buildInputs = [ nix direnv which ] ++
    lib.optionals stdenv.isDarwin [
      darwin.cf-private
      darwin.Security
      darwin.apple_sdk.frameworks.CoreServices
    ];

  doCheck = false;
}
