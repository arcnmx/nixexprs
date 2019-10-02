{ lib, config, pkgs, import, ... }: with lib; {
  # https://github.com/arcnmx/ci
  gh-actions = {
    jobs = optionalAttrs config.ci.gh-actions.emit {
      ${config.ci.gh-actions.id}.env = {
        GITHUB_EVENT_NAME = "\${{ github.event_name }}";
      };
    };
    on = {
      push = {};
      pull_request = {};
      schedule = [ {
        cron = "30 3-7/2,13-21/4 * * *";
      } ];
    };
  };
  ci = {
    configPath = "./ci/config.nix";
    gh-actions = {
      path = ".github/workflows/build.yml";
      enable = true;
    };
    env = {
      channels = {
        nixpkgs = mkDefault "unstable";
        home-manager = mkDefault "master";
      };
      cache.cachix.arc.enable = true;
    };

    project = {
      name = "arc-nixexprs";
      tasks = let
        arc = import ../. { inherit pkgs; };
        cipkgs = config.ci.env.bootstrap.pkgs;
        channel = cipkgs.nix-gitignore.gitignoreSourcePure [ ../.gitignore ''
          /ci/
          /README.md
          /.gitmodules
          /.github
          /.azure
        '' ] ../.;
      in {
        eval = {
          inputs = with cipkgs; let
            eval = attr: cipkgs.mkCiCommand {
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
        build = {
          inputs = builtins.attrValues arc.packages;
          timeoutSeconds = 60 * 180; # max 360 on azure
        };
        shells = {
          inputs = with arc.shells.rust; [ stable nightly ];
          timeoutSeconds = 60 * 90;
        };
        tests = {
          inputs = import ./tests.nix { inherit arc; };
        };
        modules = {
          name = "nix test modules";
          inputs = import ./modules.nix { inherit (arc) pkgs; };
          # TODO: depends = [ config.ci.project.tasks.eval ];
          cache = { wrap = true; };
          skip = if builtins.getEnv "GITHUB_EVENT_NAME" == "schedule" then "scheduled build"
            else if config.ci.env.channels.home-manager.version != "master" then "home-manager release channel"
            else false;
        };
      };
      stages = {
        stable = {
          ci.pkgs.system = "x86_64-linux";
          ci.env.channels = {
            nixpkgs = "19.03";
            home-manager = "release-19.03";
          };
        };
        beta = {
          ci.pkgs.system = "x86_64-linux";
          ci.env.channels.nixpkgs = "19.09";
        };
        unstable = {
          ci.pkgs.system = "x86_64-linux";
          ci.env.channels.nixpkgs = "unstable";
        };
        unstable-small = {
          ci.pkgs.system = "x86_64-linux";
          ci.env.channels.nixpkgs = "unstable-small";
          ci.warn = true;
        };
        unstable-nixpkgs = {
          ci.pkgs.system = "x86_64-linux";
          ci.env.channels.nixpkgs = "nixpkgs-unstable";
          ci.warn = true;
        };
        stable-mac = {
          ci.pkgs.system = "x86_64-darwin";
          ci.env.channels = {
            nixpkgs = "19.03";
            home-manager = "release-19.03";
          };
          ci.warn = true;
        };
        beta-mac = {
          ci.pkgs.system = "x86_64-darwin";
          ci.env.channels.nixpkgs = "19.09";
          ci.warn = true;
        };
        unstable-mac = {
          ci.pkgs.system = "x86_64-darwin";
          ci.env.channels.nixpkgs = "unstable";
          ci.warn = true;
        };
      };
    };
  };
}
