{ pkgs ? import <nixpkgs> {} }:
  if pkgs.arc.path or null == ./.
  then pkgs.arc # avoid unnecessary duplication?
  else ((pkgs.arc.super or pkgs).extend (import ./top-level.nix)).arc
