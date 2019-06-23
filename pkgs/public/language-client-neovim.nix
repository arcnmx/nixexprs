{ stdenv, fetchurl, rustPlatform, CoreServices ? null, CoreFoundation ? null }: let
  pname = "LanguageClient-neovim";
  version = "0.1.146";
  src = fetchurl {
    url = "https://github.com/autozimu/LanguageClient-neovim/archive/${version}.tar.gz";
    sha256 = "1xm98pyzf2dlh04ijjf3nkh37lyqspbbjddkjny1g06xxb4kfxnk";
  };
in rustPlatform.buildRustPackage {
  inherit pname src version;

  cargoSha256 = if stdenv.lib.versionOlder stdenv.lib.version "19.09pre"
    then "0qz7d31j7kvynswcg5j2sksn8zp654qzy1x6kjy3c13c7g9731cl"
    else "0dixvmwq611wg2g3rp1n1gqali46904fnhb90gcpl9a1diqb34sh";
  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

  # FIXME: Use impure version of CoreFoundation because of missing symbols.
  #   Undefined symbols for architecture x86_64: "_CFURLResourceIsReachable"
  preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    export NIX_LDFLAGS="-F${CoreFoundation}/Library/Frameworks -framework CoreFoundation $NIX_LDFLAGS"
  '';
}
