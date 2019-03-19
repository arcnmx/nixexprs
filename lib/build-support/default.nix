{ lib, self, super }:
let
  callLibs = file: import file { inherit lib self super; };
  sourceBashArray = name: list: builtins.toFile "source-bash-array-${name}" ''
    ${name}=(${lib.concatStringsSep " " (map (v: ''"${v}"'') list)})
  '';
  build-support =
    (callLibs ./wrap.nix) //
    (callLibs ./call.nix) //
    (callLibs ./overrides.nix) //
    (callLibs ./curl.nix) //
    {
      inherit sourceBashArray;
    };
in build-support
