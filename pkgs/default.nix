{ callPackage, callPackageOnce }:
let
  personal = import ./personal { inherit callPackage; };
  public = import ./public { inherit callPackage callPackageOnce; };
  overrides = import ./overrides.nix { inherit callPackage; };
  vimPlugins = import ./vimPlugins.nix { inherit callPackage; };
  gitAndTools = import ./git { inherit callPackage; };
  select = {
    all = personal // public;
    derivations = personal // public // vimPlugins // gitAndTools // overrides.overrides;
    overrides = overrides.overrides // {
      inherit (overrides) override;
    };
    inherit personal public vimPlugins gitAndTools;
  };
  packages = {
    inherit select;
  } // select.all;
in
packages
