{ self, ... }: let
  mozilla = pkgs: import <mozilla/package-set.nix> { inherit pkgs; };
  builders = {
    rustChannelPlatform = {
      makeRustPlatform, rustChannelOf ? (mozilla pkgs).rustChannelOf, pkgs ? null
    }: args: let
      channel = if args ? rust then args else rustChannelOf args;
      inherit (channel) rust;
    in makeRustPlatform {
      rustc = rust;
      cargo = rust;
    } // {
      inherit channel;
      rustcSrc = if channel ? rust-src
        then rust # channel.rust-src or throw?
        else throw "rust-src extension required";
    };
    rustChannel = { rustChannelPlatform, rustChannelOf ? (mozilla pkgs).rustChannelOf, pkgs ? null }: {
      stable = rustChannelOf { channel = "1.35.0"; };
      # TODO: beta
      nightly = rustChannelOf { date = "2019-06-28"; channel = "nightly"; };
    };
  };
in builtins.mapAttrs (_: p: self.callPackage p { }) builders
