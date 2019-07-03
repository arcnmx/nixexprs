{ mkShell
, rustChannel, rustChannelPlatform
, stdenv
, cargo-download, cargo-expand ? null, cargo-outdated ? null, cargo-release, cargo-bloat ? null
, cargo-llvm-lines ? null, cargo-deps ? null, cargo-with ? null, cargo-readme ? null
, rust-analyzer
}: with stdenv.lib; let
  rustTools' = [ cargo-download cargo-expand cargo-outdated cargo-release cargo-bloat cargo-llvm-lines cargo-deps cargo-with cargo-readme rust-analyzer ];
  rustTools = builtins.filter (pkg: pkg.meta.available or true) rustTools';
  extensions = [
    "clippy-preview" "rustfmt-preview"
    "rust-analysis" "rls-preview" "rust-src"
  ];
  channels = builtins.mapAttrs (_: rustChannelPlatform) { inherit (rustChannel) stable nightly; };
  targetCompat = {
    i686-pc-mingw32 = "i686-pc-windows-gnu";
    x86_64-pc-mingw32 = "x86_64-pc-windows-gnu";
  };
  targets = rec {
    linux64 = "x86_64-unknown-linux-gnu";
    mingwW64 = "x86_64-pc-windows-gnu";
    mingw32 = "i686-pc-windows-gnu";
    win64 = "x86_64-pc-windows-msvc";
    win32 = "i686-pc-windows-msvc";
    macos64 = "x86_64-apple-darwin";
    macos32 = "i686-apple-darwin";
    host = targetCompat.${stdenv.hostPlatform.config} or stdenv.hostPlatform.config;
  };
  shell = { channel, target ? targets.host }: let
    rust = builtins.attrValues channel.rust;
    cargoEnvVar = n: replaceStrings [ "-" ] [ "_" ] (toUpper n);
  in mkShell {
    nativeBuildInputs = rust ++ rustTools;
    CARGO_BUILD_TARGET = target;
    "CARGO_TARGET_${cargoEnvVar target}_LINKER" = "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc";
    "CARGO_TARGET_${cargoEnvVar target}_AR" = "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}ar";
    # TODO: NIX_LDFLAGS = "-fuse-ld=gold" or something
  };
in {
  inherit channels targets rustTools;
  mkShell = shell;

  stable = shell { channel = channels.stable; };
  nightly = shell { channel = channels.nightly; };
}
