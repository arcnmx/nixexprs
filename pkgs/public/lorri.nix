{ pkgs, fetchFromGitHub }: let
  src = fetchFromGitHub {
    owner = "target";
    repo = "lorri";
    #branch = "rolling-release";
    rev = "094a903d19eb652a79ad6e7db6ad1ee9ad78d26c";
    sha256 = "0y9y7r16ki74fn0xavjva129vwdhqi3djnqbqjwjkn045i4z78c8";
  };
in import "${src}/default.nix" {
  inherit pkgs src;
}
