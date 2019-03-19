{ callPackage }: callPackage {
  cargo-outdated = { rustPlatform, fetchFromGitHub, pkgconfig, openssl }: rustPlatform.buildRustPackage rec {
    pname = "cargo-outdated";
    version = "0.8.0";
    src = fetchFromGitHub {
      owner = "kbknapp";
      repo = "${pname}";
      #rev = "v${version}";
      rev = "8d8f08be97208a809d43d17f9088653b027fcaf1";
      sha256 = "17z9swag5kw3jbja9pvzk13k1fnjhgaz34w1wm0lvfizr14wxghy";
    };
    cargoSha256 = "0xd58wwlh3shch83bxaxnwznb3028f7i0n93h0kwh2cdacnx4cpy";
    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ openssl ];
  };
  cargo-expand = { rustPlatform, fetchFromGitHub }: rustPlatform.buildRustPackage rec {
    pname = "cargo-expand";
    version = "0.4.10";
    src = fetchFromGitHub {
      owner = "dtolnay";
      repo = "${pname}";
      rev = "${version}";
      sha256 = "1f90v67clmql2bb32sgs7c48q8nhyw2pfk4hpkiy8qll8fypjgik";
    };
    cargoSha256 = "042s28p68jz3my2q1crmq7xzcajwxmcprgg9z7r9ffhrybk4jvwz";
  };
} { }
