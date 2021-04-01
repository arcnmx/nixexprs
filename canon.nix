{ self ? pkgs
, super ? self
, pkgs ? self
, isOverlay ? false
, config ? { overrides = true; fetchurl = true; }
}@args: let
  isSuperOverlaid = args ? super && super.arc.path or null == ./.;
  isSelfOverlaid = self.arc.path or null == ./. && self ? arc._internal.overlaid'arc;
  needsInstantiation = isOverlay || !isSelfOverlaid;
  arcImpl = if isSuperOverlaid then super.arc else if !needsInstantiation then self.arc else arc';
  arc' = {
    path = ./.;
    pkgs = with super.lib; let
      pkgs' = self.appendOverlays [ (_: _: attrs) arc.overlays.python ];
      overrideAttrs = attrNames arc.packages.groups.overrides;
      pythons = builtins.attrNames super.pythonInterpreters ++ [ "python" "python2" "python3" "pypy" "pypy2" "pypy3" ];
      pythonAttrNames' = [ "pythonInterpreters" ] ++ pythons
        ++ builtins.map (py: "${py}Packages") pythons;
      pythonAttrNames = filter (k: super ? ${k}) pythonAttrNames';
      python = getAttrs pythonAttrNames pkgs';
      packages = optionalAttrs (! self ? arc._internal.overlaid'packages) (arc.packages.groups.toplevel
      // builtins.mapAttrs (k: v: super.${k} or { } // v) (arc.packages.groups.groups // arc.packages.customization)
      // arc.build);
      lib = optionalAttrs (! self ? lib.arclib) {
        lib = super.lib // arc.lib;
      };
      shells = optionalAttrs (! self ? arc._internal.overlaid'shells) {
        shells = super.shells or { } // arc.shells;
      };
      attrs = packages // lib // shells;
      missing = attrs
      // optionalAttrs (! self ? arc._internal.overlaid'python) python
      // optionalAttrs ((! self ? arc._internal.overlaid'fetchurl) && config.fetchurl) {
        inherit (pkgs') fetchurl nixpkgsFetchurl;
      } // optionalAttrs ((! self ? arc._internal.overlaid'overrides) && config.overrides) (getAttrs overrideAttrs pkgs')
      // optionalAttrs (! self ? arc._internal.overlaid'arc) { inherit arc; };
    in if missing == { } then self else self // missing // {
      callPackage = arc.pkgs.newScope { };
      newScope = scope: self.newScope (missing // scope);
    };
    super = {
      pkgs = super;
      lib = super.lib // import ./lib {
        inherit (super) lib;
      };
      arc = arc';
    };
    lib = import ./lib {
      inherit (self) lib;
      super = super.lib;
    };
    packages = import ./pkgs {
      inherit arc;
    };
    build = import ./build-support {
      inherit arc;
    };
    shells = import ./shells {
      inherit arc;
    };
    callPackageAttrs = attrs: extra:
      builtins.mapAttrs (key: pkg: arc.pkgs.callPackage pkg (self.callPackageOverrides.${key} or { } // extra)) attrs;
  };
  arc = {
    inherit (arc') path super callPackageAttrs;
    inherit (arcImpl) pkgs lib packages build shells;
  } // import ./static.nix;
in arc
