{ lib, self, super, callPackage }:
let
  callLibs = file: import file { inherit lib self super callPackage; };
  sourceBashArray = name: list: builtins.toFile "source-bash-array-${name}" ''
    ${name}=(${lib.concatStringsSep " " (map (v: ''"${v}"'') list)})
  '';
  build-support =
    (callLibs ./wrap.nix) //
    (callLibs ./call.nix) //
    (callLibs ./overrides.nix) //
    (callLibs ./curl.nix) //
    (callLibs ./linux.nix) //
    (callLibs ./kakoune.nix) //
    {
      inherit sourceBashArray;
    };
in build-support
