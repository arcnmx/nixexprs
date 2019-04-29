{ callPackage }: let
  patchPackage = pkg: let
    drv = pkg.overrideAttrs (old: {
      pname = "${old.pname}-7n";
      patches = [ ./7n.patch ];
      passthru = old.passthru // {
        exec = "${drv}/bin/${old.pname}";
      };
    });
  in drv;
in callPackage {
  yggdrasil-7n = { yggdrasil }: patchPackage yggdrasil;
  yggdrasilctl-7n = { yggdrasilctl }: patchPackage yggdrasilctl;
} { }
