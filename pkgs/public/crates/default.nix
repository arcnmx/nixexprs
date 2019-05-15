{ callPackage }: callPackage {
  rust-analyzer = { fetchFromGitHub, rustPlatform }: rustPlatform.buildRustPackage rec {
    pname = "rust-analyzer";
    version = "bebc5c71664a144b9addd357eb503f776f2cf416";
    src = fetchFromGitHub {
      owner = "rust-analyzer";
      repo = "rust-analyzer";
      rev = version;
      sha256 = "0aj5lzilayxjrhmnswciki37inn07p1z6ksf3kr65icqvs7b6w0s";
    };
    cargoBuildFlags = ["--features" "jemalloc" "-p" "ra_lsp_server"];

    cargoSha256 = "11h60kcf2g050w97lkc7dwdinrbay459q2ccyw3cxl8620p95a8v";

    doCheck = false;
  };
} { }
