let
  rev = "f5d3a1204c7e314802c1d00c7c596fdf5b8229a8";
  sha256 = "17i9vrfgd7zw0ycsmw651zrjfy6kyif9bvlykrkd87m75d64cb2m";
  clip = builtins.fetchTarball {
    url = "https://github.com/arcnmx/clip/archive/${rev}.tar.gz";
    inherit sha256;
  };
in import (clip + "/derivation.nix")
