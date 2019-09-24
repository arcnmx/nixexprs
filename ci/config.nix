{ ci }: let
  pkgs = ci.channels.nixpkgs;
in {
  # https://github.com/arcnmx/ci
  channels = {
    nixpkgs = "unstable";
    home-manager = "master";
    mozilla = "master";
  } // ci.channelsFromEnv ci.screamingSnakeCase "NIX_CHANNELS_";

  allowRoot = (builtins.getEnv "CI_ALLOW_ROOT") != "";
  closeStdin = (builtins.getEnv "CI_CLOSE_STDIN") != "";

  #glibcLocales = [ pkgs.glibcLocales ];

  cache.cachix = ci.cachixFromEnv { };

  tasks = let
    arc = import ../. { inherit pkgs; };
    channel = ci.cipkgs.nix-gitignore.gitignoreSourcePure [ ../.gitignore ''
      /ci/
      /README.md
      /.gitmodules
      /.azure
    '' ] ../.;
  in {
    eval = ci.mkCiTask {
      pname = "eval";
      inputs = with ci.cipkgs; with ci.env; let
        eval = attr: ci.mkCiCommand {
          pname = "eval-${attr}";
          displayName = "nix eval ${attr}";
          timeout = 60;
          src = channel;

          nativeBuildInputs = [ nix ];
          command = "nix eval -f $src/default.nix ${attr}";
          hostExec = true; # nix doesn't work inside builders ("recursive nix")
        };
      in [ (eval "lib") (eval "modules") (eval "overlays") ];
    };
    build = ci.mkCiTask {
      pname = "build";
      inputs = builtins.attrValues arc.packages;
      timeout = 60 * 180; # max 360 on azure
    };
    shells = ci.mkCiTask {
      pname = "shells";
      inputs = with arc.shells.rust; [ stable nightly ];
      timeout = 60 * 90;
    };
    tests = ci.mkCiTask {
      pname = "tests";
      inputs = import ./tests.nix { inherit arc; };
    };
    modules = ci.mkCiTask {
      pname = "modules";
      displayName = "nix test modules";
      inputs = import ./modules.nix { inherit (arc) pkgs; };
      depends = [ ci.config.tasks.eval ];
      cache = { wrap = true; };
      skip = if builtins.getEnv "BUILD_REASON" == "Schedule" then "scheduled build"
        else if ci.config.channels.home-manager != "master" then "home-manager release channel"
        else false;
    };
  };
}
