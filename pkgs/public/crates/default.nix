{ callPackage }: callPackage {
  rust-analyzer = { fetchFromGitHub, rustPlatform, lib, darwin, hostPlatform }: rustPlatform.buildRustPackage rec {
    pname = "rust-analyzer";
    version = "bebc5c71664a144b9addd357eb503f776f2cf416";
    src = fetchFromGitHub {
      owner = "rust-analyzer";
      repo = pname;
      rev = version;
      sha256 = "0aj5lzilayxjrhmnswciki37inn07p1z6ksf3kr65icqvs7b6w0s";
    };
    cargoBuildFlags = ["--features" "jemalloc" "-p" "ra_lsp_server"];
    buildInputs = lib.optionals hostPlatform.isDarwin [ darwin.cf-private darwin.apple_sdk.frameworks.CoreServices ];
    # darwin undefined symbol _CFURLResourceIsReachable: https://discourse.nixos.org/t/help-with-rust-linker-error-on-darwin-cfurlresourceisreachable/2657

    cargoSha256 = "11h60kcf2g050w97lkc7dwdinrbay459q2ccyw3cxl8620p95a8v";
    meta.broken = lib.versionOlder lib.version "19.09pre";

    doCheck = false;
  };
} { }
