{ lib, mkShell, writeShellScriptBin, rustChannelOf, makeRustPlatform, pkgsCross, hostPlatform, gcc
, cargo-download, cargo-expand ? null, cargo-outdated ? null, cargo-release, cargo-bloat ? null
#, cargo-llvm-lines, cargo-deps, cargo-with, cargo-readme
, rust-analyzer
}: let
  rustTools = builtins.filter (pkg: pkg.meta.available or true) [ cargo-download cargo-expand cargo-outdated cargo-release cargo-bloat rust-analyzer ];
  channels' = {
    nightly = rustChannelOf { date = "2019-05-22"; channel = "nightly"; };
    stable = rustChannelOf { channel = "1.35.0"; };
  };
  extensions = [
    "clippy-preview" "rustfmt-preview"
    "rust-analysis" "rls-preview" "rust-src"
  ];
  channels = lib.mapAttrs (_: ch: let
    rust = ch.rust.override { inherit extensions; };
  in makeRustPlatform {
    rustc = rust;
    cargo = rust;
  }) channels';
  rustGccGold = "${writeShellScriptBin "rust-gcc-gold" ''
    exec ${gcc}/bin/gcc -fuse-ld=gold "$@"
  ''}/bin/rust-gcc-gold";
  environment = {
    x86_64-unknown-linux-gnu = {
      CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER = "${rustGccGold}";
    };
    x86_64-pc-windows-gnu ={
      CARGO_TARGET_X86_64_PC_WINDOWS_GNU_LINKER = "${pkgsCross.mingwW64.buildPackages.gcc}/bin/x86_64-pc-mingw32-gcc";
      CARGO_TARGET_X86_64_PC_WINDOWS_GNU_AR = "${pkgsCross.mingwW64.buildPackages.binutils.bintools}/bin/x86_64-pc-mingw32-ar";
    };
    i686-pc-windows-gnu ={
      CARGO_TARGET_I686_PC_WINDOWS_GNU_LINKER = "${pkgsCross.mingw32.buildPackages.gcc}/bin/i686-pc-mingw32-gcc";
      CARGO_TARGET_I686_PC_WINDOWS_GNU_AR = "${pkgsCross.mingw32.buildPackages.binutils.bintools}/bin/i686-pc-mingw32-ar";
    };
    # TODO: MSVC wine targets
  };
  targets = rec {
    linux64 = "x86_64-unknown-linux-gnu";
    mingwW64 = "x86_64-pc-windows-gnu";
    mingw32 = "i686-pc-windows-gnu";
    win64 = "x86_64-pc-windows-msvc";
    win32 = "i686-pc-windows-msvc";
    macos64 = "x86_64-apple-darwin";
    macos32 = "i686-apple-darwin";
    host = if hostPlatform.isLinux then linux64
    else if hostPlatform.isDarwin then macos64
    else throw "unknown host platform";
  };
  shell = { channel, target ? targets.host }: let
    rust = channel.rust.rustc;
    environment' = environment.${target} or { };
  in mkShell {
    nativeBuildInputs = [ rust ] ++ rustTools;
  } // environment';
in {
  inherit (channels) nightly stable;
  inherit targets;

  shell = {
    stable = shell { channel = channels.stable; };
    nightly = shell { channel = channels.nightly; };

    __functor = shell;
  };
}
