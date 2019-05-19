{ callPackage, callPackageOnce }: {
  rust = callPackageOnce ./rust.nix { };
}
