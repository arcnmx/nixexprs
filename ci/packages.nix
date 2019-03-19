{ arc }:
let
  packages = (builtins.attrValues arc.packages.select.derivations);
  filter = pkg: pkg ? meta.broken -> !pkg.meta.broken;
in
builtins.filter filter packages
