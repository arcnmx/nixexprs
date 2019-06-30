{ arc }:
let
  packages = (builtins.attrValues arc.packages.select.derivations);
  filter = pkg: (pkg ? meta.broken -> !pkg.meta.broken) &&
    (pkg ? meta.skip.ci -> !pkg.meta.skip.ci) &&
    (pkg ? meta.available -> pkg.meta.available);
in
builtins.filter filter packages
