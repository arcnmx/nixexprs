{ arc }:
let
  packages = (builtins.attrValues arc.packages.select.derivations);
  filter = pkg: (pkg ? meta.broken -> !pkg.meta.broken) &&
    (pkg ? meta.skip.ci -> !pkg.meta.skip.ci);
in
builtins.filter filter packages
