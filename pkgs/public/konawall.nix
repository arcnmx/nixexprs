{ fetchFromGitHub, rustPlatform, lib, pkg-config, openssl, libX11, libXrandr }: rustPlatform.buildRustPackage rec {
  pname = "konawall-rs";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "kittywitch";
    repo = pname;
    rev = "7643e4a3c87d612ca8d5a1fdffde29ff797becd4";
    sha256 = "18zcrang0gqlkzcqyi5rrw12iyy4bhwp1yssi325bfabr868mjiz";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl libX11 libXrandr ];

  meta = with lib; {
    platforms = platforms.linux;
    broken = ! versionAtLeast rustPlatform.rust.rustc.version "1.53.0";
  };

  cargoSha256 = "034njg7nx31lahnw906hvifihzij589braggnbp22bbyr0m5qiff";
}
