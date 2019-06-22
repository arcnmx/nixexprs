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
      yarn2nix = let
        yarn2nix = ../../yarn2nix/default.nix;
      in if builtins.pathExists yarn2nix
      then callPackage yarn2nix {}
      else super.yarn2nix;
    };
in build-support
