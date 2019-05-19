{ callPackage, callPackageOnce }:
{
  i3gopher = callPackage ./i3gopher {};
  inherit (callPackage ./yggdrasil {}) yggdrasil yggdrasilctl;
  tamzen = callPackage ./tamzen.nix {};
  lorri = callPackage ./lorri.nix {};
  paswitch = callPackage ./paswitch.nix {};
  LanguageClient-neovim = callPackage ./language-client-neovim.nix {};
  tridactyl = callPackage ./tridactyl.nix {};
  yarn2nix = let
    yarn2nix = ../../yarn2nix/default.nix;
  in if builtins.pathExists yarn2nix
  then callPackageOnce yarn2nix {}
  else callPackageOnce ({ yarn2nix }: yarn2nix) {};
} // (import ./nixos.nix { inherit callPackage; })
// (import ./droid.nix { inherit callPackage; })
// (import ./crates { inherit callPackage; })
// (import ./programs.nix { inherit callPackage; })
// (import ./linux { inherit callPackage; })
