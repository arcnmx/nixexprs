{ arc }:
let
  packages = (builtins.attrValues arc.packages.select.derivations);
  filter = pkg: !(pkg.meta.broken or false) &&
    !(pkg.meta.skip.ci or false) &&
    pkg.meta.available or true;
in
builtins.filter filter packages
