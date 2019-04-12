{ callPackage }: callPackage {
  cargo-outdated = { arc, rustPlatform, fetchFromGitHub, pkgconfig, openssl }: rustPlatform.buildRustPackage rec {
    name = "${pname}-${version}";
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
    meta.broken = !arc.lib.isRust2018 rustPlatform;
  };
} { }
