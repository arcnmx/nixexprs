{ buildGoPackage, fetchFromGitHub }:
let
  version = "0.1.0";
  package = buildGoPackage {
    name = "i3gopher-${version}";
    inherit version;
    goPackagePath = "github.com/quite/i3gopher";
    src = fetchFromGitHub {
      owner = "quite";
      repo = "i3gopher";
      rev = "v${version}";
      sha256 = "1c22hxfspgg3dx1yr52spw8vpw3h170yb81d2lwx9jfnydpf1krl";
    };

    goDeps = ./deps.nix;

    passthru = {
      exec = "${package}/bin/i3gopher";
    };
  };
in package
