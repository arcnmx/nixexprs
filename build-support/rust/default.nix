{ self, super, lib, ... }: let

  /* Find mozilla overlay or pinned fallback
  mozillaOverlayRev = "b52a8b7de89b1fac49302cbaffd4caed4551515f";
  mozilla = channelOrPin {
    name = "mozilla";
    check = pkgs: pkgs.latest or null;
    imp = channel: pkgs: import (channel + "/package-set.nix") { inherit pkgs; };
    url = "https://github.com/mozilla/nixpkgs-mozilla/archive/${mozillaOverlayRev}.tar.gz";
    sha256 = lib.fakeSha256;
  };*/

  # Find rust overlay or pinned fallback
  rust = lib.channelOrPin {
    name = "rust";
    check = pkgs: pkgs.rustChannel or null;
    imp = channel: pkgs: import (channel + "/default.nix") { inherit pkgs; };
    url = "https://github.com/arcnmx/nixexprs-rust/archive/${rustOverlayRev}.tar.gz";
    sha256 = "0df24929sx9n223cc9fz4r2swr73xa790sbcds0p7f4mmk47461f";
  };
  rustOverlayRev = "b173d0ce9f178391357533f33a9a8da60921e630";
  rustPlatformFor = { rustPlatform, ... }: rustPlatform;

  builders = {
    rustPlatforms = { rustChannel ? rust pkgs, pkgs ? null }: with lib;
      mapAttrs (_: rustPlatformFor) rustChannel.releases // {
        stable = rustPlatformFor rustChannel.releases."1.64.0";
        # An occasionally pinned unstable release
        # Check https://rust-lang.github.io/rustup-components-history/ before updating this to avoid breaking things
        nightly = rustPlatformFor (rustChannel.nightly.override {
          date = "2022-10-04";
          sha256 = "sha256-/fCyWfvJzlGeRfsUycEav40Yi7hHacGzfSDQjACCLmw=";
          manifestPath = ./channel-rust-nightly.toml;
          rustcDev = true;
        });
        impure = mapAttrs (_: rustPlatformFor) {
          inherit (rustChannel) stable beta nightly;
        };
      };
    rustPlatformFor = { rustChannel ? rust pkgs, pkgs ? null }: args:
      rustPlatformFor (rustChannel.distChannel args);
  };
in builders
