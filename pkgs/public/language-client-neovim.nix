{ lib, stdenv, fetchurl, rustPlatform, darwin }: let
  pname = "LanguageClient-neovim";
  version = "0.1.160";
  src = fetchurl {
    url = "https://github.com/autozimu/LanguageClient-neovim/archive/${version}.tar.gz";
    sha256 = "0l01pjaclsy7lyc8a8y517fnqgxmhf9kccjnbjrx6l6p36p0jbig";
  };
in rustPlatform.buildRustPackage {
  inherit pname src version;

  cargoSha256 = "1a2vm5lsiismqipmaaic0574lyxqvcrn1bimsshj1j8mq8gb3wwi";
  buildInputs = with darwin.apple_sdk.frameworks; lib.optionals stdenv.isDarwin [ CoreFoundation CoreServices ];
  meta.broken = lib.versionAtLeast "1.40.0" rustPlatform.rust.rustc.version;
}
