{ ci }: let
  pkgs = import <nixpkgs> { };
in {
  # https://github.com/arcnmx/ci
  channels = {
    home-manager = "master";
    mozilla = "master";
  } // ci.channelsFromEnv ci.screamingSnakeCase "NIX_CHANNELS_";
  nixPath = {
    nixpkgs = "https://github.com/arcnmx/nixpkgs/archive/pending-pr.tar.gz";
  };

  allowRoot = (builtins.getEnv "CI_ALLOW_ROOT") != "";
  closeStdin = (builtins.getEnv "CI_CLOSE_STDIN") != "";

  #glibcLocales = [ pkgs.glibcLocales ];

  cache.cachix = {
    arc = { };
  };
}
