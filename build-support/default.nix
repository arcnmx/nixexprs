{ self, super, lib, ... }: let
  call = file: import file { inherit self super lib; };

  sourceBashArray = name: list: with self.lib; builtins.toFile "source-bash-array-${name}" ''
    ${name}=(${concatStringsSep " " (map escapeShellArg list)})
  '';

  build-support =
    (call ./wrap.nix) //
    #(call ./call.nix) //
    (call ./exec.nix) //
    (call ./curl.nix) //
    (call ./linux.nix) //
    (call ./kakoune.nix) //
    (call ./rust.nix) //
    (call ./misc.nix) //
    {
      inherit sourceBashArray;
      yarn2nix = let
        yarn2nix = ../yarn2nix/default.nix;
      in if builtins.pathExists yarn2nix
      then self.callPackage yarn2nix {}
      else super.yarn2nix;
    };
in build-support
