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
    sha256 = "0n71yzxq0ww53r9h3s78dlawn18gd9rngbwvymm0xjkvcl4gbfk9";
  };
  rustOverlayRev = "9a630deb8192472ad08bde6388fbdbfa1a257d77";
  rustPlatformFor = { rustPlatform, ... }: rustPlatform;

  builders = {
    rustPlatforms = { rustChannel ? rust pkgs, pkgs ? null }: with lib;
      mapAttrs (_: rustPlatformFor) rustChannel.releases // {
        stable = rustPlatformFor rustChannel.releases."1.38.0";
        # An occasionally pinned unstable release
        # Check https://rust-lang.github.io/rustup-components-history/ before updating this to avoid breaking things
        nightly = rustPlatformFor (rustChannel.nightly.override {
          date = "2019-09-13";
          sha256 = "06881g7ba2hzmfq5vaz888d2q762zf4bxjc621rw3g8z702ps7w9";
          manifestPath = ./channel-rust-nightly.toml;
        });
        impure = mapAttrs (_: rustPlatformFor) {
          inherit (rustChannel) stable beta nightly;
        };
      };
    rustPlatformFor = { rustChannel ? rust pkgs, pkgs ? null }: args:
      rustPlatformFor (rustChannel args);
  };
in builtins.mapAttrs (_: p: self.callPackage p { }) builders