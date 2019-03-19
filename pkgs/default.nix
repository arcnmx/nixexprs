{ callPackage }:
let
  personal = import ./personal { inherit callPackage; };
  public = import ./public { inherit callPackage; };
  vimPlugins = import ./vimPlugins.nix { inherit callPackage; };
  gitAndTools = import ./git { inherit callPackage; };
  select = {
    all = personal // public;
    derivations = personal // public // vimPlugins // gitAndTools;
    inherit personal public vimPlugins gitAndTools;
  };
  packages = {
    inherit select;
  } // select.all;
in
packages
