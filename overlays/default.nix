let
  lib = import ../lib {
    # we can get away with using some functions by passing builtins as lib
    lib = {
      foldl = builtins.foldl';
    } // builtins;
  };
  overlays = {
    arc = import ./arc.nix;
    lib = import ./lib.nix;
    fetchurl = import ./fetchurl.nix;
    shells = import ./shells.nix;
    python = import ./python.nix;
    packages = import ./packages.nix;
    overrides = import ./overrides.nix;
    ordered = [
      overlays.arc
      overlays.lib
      overlays.python
      overlays.packages
      overlays.overrides
      overlays.fetchurl
      overlays.shells
    ];

    all = lib.composeManyExtensions overlays.ordered;

    wrap = pkgs: pkgs.appendOverlays overlays.ordered;

    __functor = self: self.all;
  };
in overlays
