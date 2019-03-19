{ callPackage }: let
  wrapScript = { lib, path, stdenvNoCC, makeWrapper, name, source, paths }: stdenvNoCC.mkDerivation {
    inherit source name;
    nativeBuildInputs = [makeWrapper];
    wrapperPath = lib.makeBinPath paths;
    unpackPhase = "true";
    configurePhase = "true";
    buildPhase = "true";
    installPhase = ''
      install -d $out/bin
      makeWrapper $source/bin/$name $out/bin/$name \
        --prefix PATH : $wrapperPath \
        --set-default NIX_PATH nixpkgs=${path}
    '';
  };
  packages = {
    nixos-enter = { lib, path, stdenvNoCC, makeWrapper, man, nixos, utillinux, coreutils }: let
      nixos' = nixos {};
    in wrapScript {
        inherit lib path stdenvNoCC makeWrapper;
        name = "nixos-enter";
        source = nixos'.nixos-enter;
        paths = [nixos'.manual.manpages man utillinux coreutils];
      };
    /*nixos-generate-config = { nixos, man }: let
      nixos' = nixos {};
    in nixos'.nixos-generate-config.overrideAttrs (old: {
      path = old.path ++ [nixos.manual.manpages man];
    });*/
    nixos-generate-config = { lib, path, stdenvNoCC, makeWrapper, man, coreutils, btrfs-progs, nixos }: let
      nixos' = nixos {};
    in wrapScript {
        inherit lib path stdenvNoCC makeWrapper;
        name = "nixos-generate-config";
        source = nixos'.nixos-generate-config;
        /*source = nixos'.nixos-generate-config.overrideAttrs (_: {
          paths = lib.makeBinPath [tools.nixos-enter];
        });*/
        paths = [nixos'.manual.manpages man coreutils btrfs-progs];
      };
    nixos-install = { lib, path, stdenvNoCC, makeWrapper, man, nixos, coreutils, nix }: let
      nixos' = nixos {};
    in wrapScript {
        inherit lib path stdenvNoCC makeWrapper;
        name = "nixos-install";
        source = nixos'.nixos-install.overrideAttrs (_: {
          paths = lib.makeBinPath [tools.nixos-enter];
        });
        paths = [nixos'.manual.manpages man coreutils nix];
      };
    nixos-option = { lib, path, stdenvNoCC, makeWrapper, man, nixos, coreutils, gnused, nix }: let
      nixos' = nixos {};
    in wrapScript {
        inherit lib path stdenvNoCC makeWrapper;
        name = "nixos-option";
        source = nixos'.nixos-option;
        paths = [nixos'.manual.manpages man coreutils gnused nix];
      };
    nixos-rebuild = { lib, path, stdenvNoCC, makeWrapper, man, nixos, coreutils, openssh, nix }: let
      nixos' = nixos {};
    in wrapScript {
        inherit lib path stdenvNoCC makeWrapper;
        name = "nixos-rebuild";
        source = nixos'.nixos-rebuild.overrideAttrs (_: { inherit nix; });
        paths = [nixos'.manual.manpages man coreutils openssh];
      };
  };
  tools = callPackage packages { };
in tools
