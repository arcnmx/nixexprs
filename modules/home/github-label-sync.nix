{ config, pkgs, lib, ... }: with lib; let
  cfg = config.programs.github-label-sync;
  arc = import ../../canon.nix { inherit pkgs; };
  loadJSON = json: if isList json then json else importJSON json;
  processJSON = mapListToAttrs (label: nameValuePair label.name ({
    inherit (label) name;
    colour = label.color;
  } // optionalAttrs (label ? description) {
    inherit (label) description;
  } // optionalAttrs (label ? aliases) {
    inherit (label) aliases;
  }));
  labelModule = { name, config, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
      };
      colour = mkOption {
        type = base16.types.colourType;
      };
      description = mkOption {
        type = with types; nullOr str;
        default = null;
      };
      aliases = mkOption {
        type = with types; listOf str;
        default = [ ];
      };
      out = mkOption {
        type = types.attrs;
      };
    };
    config.out = {
      inherit (config) name aliases;
      color = config.colour.rgb;
    } // optionalAttrs (config.description != null) {
      inherit (config) description;
    };
  };
  labelsModule = { name, config, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
      };
      labels = mkOption {
        type = with types; attrsOf (submodule labelModule);
        default = { };
      };
      json = mkOption {
        type = with types; nullOr (either path (listOf attrs));
        default = null;
      };
      combineJson = mkEnableOption "augment JSON labels";
      out = {
        json = mkOption {
          type = with types; either path (listOf attrs);
        };
        path = mkOption {
          type = types.path;
        };
      };
    };
    config = {
      combineJson = mkDefault (isList config.json);
      labels = mkIf (config.combineJson && config.json != null) (processJSON (loadJSON config.json));
      out = {
        json = if config.combineJson || config.json == null
          then mapAttrsToList (_: l: l.out) config.labels
          else config.json;
        path = if isList config.out.json
          then pkgs.writeText "github-label-sync-${config.name}.json" (builtins.toJSON config.out.json)
          else config.out.json;
      };
    };
  };
  wrap = key: labels: pkgs.writeShellScriptBin "github-label-sync-${key}" ''
    exec ${cfg.package}/bin/github-label-sync --labels ${labels.out.path} "$@"
  '';
in {
  options.programs.github-label-sync = {
    enable = mkEnableOption "github-label-sync";
    sensible.enable = mkEnableOption "@seantrane/github-label-presets";
    package = mkOption {
      type = types.package;
      default = pkgs.github-label-sync or arc.packages.github-label-sync;
      defaultText = literalExpression "pkgs.github-label-sync";
    };
    labels = mkOption {
      type = with types; attrsOf (submodule labelsModule);
      default = { };
    };
  };
  config = mkMerge [ (mkIf cfg.enable {
    home.packages = singleton cfg.package
    ++ mapAttrsToList wrap cfg.labels;
  }) {
    programs.github-label-sync.labels = {
      sensible = let
        #label-presets-rev = "732222d9e116c36edb0f2affd1910ba5ae841686";
        label-presets-rev = "621baffca38503bab31713acd133cf2ebaf10a77";
        label-presets-source = pkgs.fetchzip {
          url = "https://github.com/seantrane/github-label-presets/archive/${label-presets-rev}.tar.gz";
          sha256 = "0hfrz7glpqd18c7zcvwy5l25k7srciwz06qjpzprxq8zc44dq3ma";
        };
      in mkIf cfg.sensible.enable {
        json = "${label-presets-source}/labels.json";
      };
    };
  } ];
}
