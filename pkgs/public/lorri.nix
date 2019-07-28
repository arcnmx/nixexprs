{ lib, callPackage, stdenv, fetchFromGitHub, makeWrapper, rustPlatform, coreutils, nix, direnv, which, darwin }: rustPlatform.buildRustPackage rec {
  src = fetchFromGitHub {
    owner = "target";
    repo = "lorri";
    #branch = "rolling-release";
    rev = "d3e452ebc2b24ab86aec18af44c8217b2e469b2a";
    sha256 = "07yf3gl9sixh7acxayq4q8h7z4q8a66412z0r49sr69yxb7b4q89";
  };
  pname = "lorri";
  version = "rolling-release";
  cargoSha256 = if lib.isNixpkgsStable
    then lib.fakeSha256
    else "094w2lp6jvxs8j59cjqp6b3kg4y4crlnqka5v2wmq4j0mn6hvhsj";
  COREUTILS = coreutils;
  BUILD_REV_COUNT = 1;
  RUN_TIME_CLOSURE = callPackage "${src}/nix/runtime.nix" { };

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
