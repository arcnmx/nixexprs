{ callPackage }:
{
  i3gopher = callPackage ./i3gopher {};
  inherit (callPackage ./yggdrasil {}) yggdrasil yggdrasilctl;
  tamzen = callPackage ./tamzen.nix {};
  lorri = callPackage ./lorri.nix {};
} // (import ./nixos.nix { inherit callPackage; })
// (import ./droid.nix { inherit callPackage; })
// (import ./crates { inherit callPackage; })
// (import ./programs.nix { inherit callPackage; })
