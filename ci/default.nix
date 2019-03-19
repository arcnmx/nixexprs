let
  config = { allowUnfree = true; doCheckByDefault = false; };
  overlays = [(import ../overlay.nix)];
  pkgss = [
    (import <nixpkgs> { inherit config; })
    (import <nixpkgs> { inherit config overlays; })
  ];
  test = pkgs: let
    arc = import ../default.nix { inherit pkgs; };
  in {
    packages = import ./packages.nix { inherit arc; };
    tests = import ./tests.nix {
      pkgs = import ../overlays/include.nix pkgs;
      inherit arc;
    };
  };
  module = import ./modules.nix;
  tests' = map test pkgss;
  lib = (import <nixpkgs> {}).lib;
  tests = lib.foldAttrs (n: a: n ++ a) [] tests';
  modules = map module pkgss;
in {
  inherit (tests) packages tests;
  inherit modules;
}
