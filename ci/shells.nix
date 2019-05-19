{ arc, pkgs }:
let
  mkShell = attrs: pkgs.mkShell (attrs // {
    nobuildPhase = "touch $out";
  });
  rust = arc.shells.rust.override { inherit mkShell; };
  shells = pkgs.lib.optionals (pkgs ? rustChannelOf) [ rust.shell.stable rust.shell.nightly ];
in
shells
