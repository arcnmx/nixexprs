{ arc }:
let
  mkShell = attrs: arc.pkgs.mkShell (attrs // {
    nobuildPhase = "echo $buildInputs $nativeBuildInputs > $out";
  });
  rust = arc.shells.rust.override { inherit mkShell; };
  shells = arc.pkgs.lib.optionals (arc.pkgs ? rustChannelOf) [ rust.stable rust.nightly ];
in
shells
