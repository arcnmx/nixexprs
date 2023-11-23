{ pkgs ? import <nixpkgs> { }
, arc ? (import ../canon.nix { inherit pkgs; })
, self ? arc.pkgs
, super ? arc.super.pkgs
, lib ? arc.super.lib
}: let
  call = file: arc.callPackageAttrs (import file { inherit self super lib; }) { };

  sourceBashArray = name: list: with self.lib; builtins.toFile "source-bash-array-${name}" ''
    ${name}=(${concatStringsSep " " (map escapeShellArg list)})
  '';

  build-support =
    (call ./wrap.nix) //
    #(call ./call.nix) //
    (call ./exec.nix) //
    (call ./shell.nix) //
    (call ./fetchurl.nix) //
    (call ./curl.nix) //
    (call ./kakoune.nix) //
    (call ./weechat.nix) //
    (call ./misc.nix) //
    (import ./yggdrasil.nix { inherit self super lib; }) //
    (import ./zsh.nix { inherit self super lib; }) //
    (import ./vim { inherit self super lib; }) //
    (import ./linux.nix { inherit self super lib; }) //
    {
      inherit sourceBashArray;

      nodeEnv = self.callPackage (self.path + "/pkgs/development/node-packages/node-env.nix") { };
    };
in build-support
