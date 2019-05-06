self: super: let
  arc = import ../top-level.nix {
    callPackage = self.newScope arc.packages.select.personal;
    inherit super;
    inherit (super) lib;
  };
  overlay = {
    arc = arc
      // { __overlaid = true; };
    lib = (super.lib or {}) // arc.lib;
    vimPlugins = super.vimPlugins // arc.packages.select.vimPlugins;
    gitAndTools = super.gitAndTools // arc.packages.select.gitAndTools;
    linuxPackagesFor = kernel: (super.linuxPackagesFor kernel).extend (super.lib.const (ksuper: {
      ax88179_178a = arc.ax88179_178a.override { linux = ksuper.kernel; };
    }));
  } // arc.packages.select.public // arc.lib.build-support;
in overlay
