{ lib, config, pkgs, channels, env, import, ... }: with lib; let
  skipModules = true;
  arc = import ../. { inherit pkgs; overlay = true; };
  channel = channels.cipkgs.nix-gitignore.gitignoreSourcePure [ ../.gitignore ''
    /ci/
    /README.md
    /.azure
    .gitmodules
    .github
    .git
  '' ] ../.;
in {
  # https://github.com/arcnmx/ci
  name = "arc-nixexprs";
  ci = {
    version = "v0.6";
    configPath = "./ci/config.nix";
    gh-actions = {
      path = ".github/workflows/build.yml";
      enable = true;
    };
  };
  gh-actions = {
    on = {
      push = {};
      pull_request = {};
      schedule = [ {
        cron = "30 */2 * * *";
      } ];
    };
  };
  channels = {
    nixpkgs = {
      version = mkDefault "unstable";
      nixPathImport = skipModules == false;
      args.config = {
        checkMetaRecursively = true;
        permittedInsecurePackages = [
          # allow notmuch/notmuch-vim to build
          "ruby-2.7.8"
          "openssl-1.1.1t"
          "openssl-1.1.1u"
          "openssl-1.1.1v"
          "openssl-1.1.1w"
        ];
      };
    };
    home-manager = mkDefault "master";
  };
  cache.cachix.arc = {
    publicKey = "arc.cachix.org-1:DZmhclLkB6UO0rc0rBzNpwFbbaeLfyn+fYccuAy7YVY=";
    signingKey = "mew"; # TODO: fix and remove
  };

  tasks = {
    eval = {
      inputs = with channels.cipkgs; let
        eval = attr: ci.command {
          name = "eval-${attr}";
          displayName = "nix eval ${attr}";
          timeout = 60;
          src = channel;

          nativeBuildInputs = [ nix ];
          command = "nix eval -f $src/default.nix ${attr}";
          impure = true; # nix doesn't work inside builders ("recursive nix")
        };
      in [ (eval "lib") (eval "modules") (eval "overlays") ];
    };
    build = {
      inputs = arc.packages.groups.all;
      timeoutSeconds = 60 * 180; # max 360 on azure
    };
    tests = {
      inputs = import ./tests.nix { inherit arc pkgs; ci = channels.cipkgs.ci; };
    };
    modules = {
      name = "nix test modules";
      inputs = optionals (skipModules == false) (import ./modules.nix { inherit (arc) pkgs; });
      # TODO: depends = [ config.tasks.eval.drv ];
      cache = { wrap = true; };
      skip = skipModules;
    };
  };
  jobs = {
    stable = {
      system = "x86_64-linux";
      channels = {
        nixpkgs.version = "stable";
        home-manager = "release-22.11";
      };
    };
    unstable = {
      system = "x86_64-linux";
      channels.nixpkgs.version = "unstable";
    };
    unstable-small = {
      system = "x86_64-linux";
      channels.nixpkgs.version = "unstable-small";
      warn = true;
    };
    unstable-nixpkgs = {
      system = "x86_64-linux";
      channels.nixpkgs.version = "nixpkgs-unstable";
      warn = true;
    };
    stable-mac = {
      ci.gh-actions.enable = mkForce false;
      system = "x86_64-darwin";
      channels = {
        nixpkgs.version = "21.05";
        home-manager = "release-21.05";
      };
      warn = true;
    };
    unstable-mac = {
      ci.gh-actions.enable = mkForce false;
      system = "x86_64-darwin";
      channels.nixpkgs.version = "unstable";
      warn = true;
    };
  };
}
