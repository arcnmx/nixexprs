{ super, lib, callPackage }:
let
  arc_lib = import ./lib { inherit lib super callPackage; };
  arc_pkgs = import ./pkgs {
    callPackage = arc_lib.callFunctionAs callPackage;
  };
  arc = {
    lib = arc_lib;
    modules = import ./modules;
    overlays = import ./overlays;
    packages = arc_pkgs;
  } // arc_pkgs.select.all // arc_lib.build-support;
in arc
