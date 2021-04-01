{ pkgs ? import <nixpkgs> {}, overlay ? false }:
  if overlay then (pkgs.extend (import ./overlay.nix)).arc
  else import ./canon.nix { inherit pkgs; }
