{ pkgs ? import <nixpkgs> {} }:
let
  pkgs' = import ./overlays/include.nix pkgs;
in
pkgs'.arc
