{ pkgs ? import <nixpkgs> {} }:
let
  pkgs' = import ./overlays/include.nix { inherit pkgs; };
in
pkgs'.arc
