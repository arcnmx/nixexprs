{ fetchFromGitHub, rustPlatform, lib, pkg-config, openssl, libX11, libXrandr }: rustPlatform.buildRustPackage rec {
  pname = "konawall-rs";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "kittywitch";
    repo = pname;
    rev = "cec3c6323ee2328b162c272e0ce3c1e022fceb3a";
    sha256 = "1p8m606bdrg75mhicbqaj187q496biqv4g4hs4kwv3bab6h6jn90";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl libX11 libXrandr ];

  meta = with lib; {
    platforms = platforms.linux;
    broken = ! versionAtLeast rustPlatform.rust.rustc.version "1.53.0";
  };

  cargoSha256 = "034njg7nx31lahnw906hvifihzij589braggnbp22bbyr0m5qiff";
}
