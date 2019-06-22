{ callPackage, callPackageOnce }:
{
  i3gopher = callPackage ./i3gopher {};
  inherit (callPackage ./yggdrasil {}) yggdrasil yggdrasilctl;
  tamzen = callPackage ./tamzen.nix {};
  lorri = callPackage ./lorri.nix {};
  paswitch = callPackage ./paswitch.nix {};
  LanguageClient-neovim = callPackage ./language-client-neovim.nix {};
  tridactyl = callPackage ./tridactyl.nix {};
  base16-shell = callPackage ./base16-shell.nix {};
  urxvt_osc_52 = callPackage ./urxvt-osc-52.nix {};
} // (import ./nixos.nix { inherit callPackage; })
// (import ./droid.nix { inherit callPackage; })
// (import ./crates { inherit callPackage; })
// (import ./programs.nix { inherit callPackage; })
// (import ./linux { inherit callPackage; })
