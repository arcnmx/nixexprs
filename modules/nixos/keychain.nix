isNixos: { pkgs, config, lib, ... }: with lib; let
  config_ = config;
  cfg = config.keychain;
  activationScript = ''
    ${pkgs.coreutils}/bin/install -dm 0755 ${cfg.root}
    ${concatStringsSep "\n" (mapAttrsToList (_: f: ''
      ${pkgs.coreutils}/bin/install -Dm${f.mode} -o${f.owner} -g${f.group} ${f.sourceFile} ${f.path}
    '') config.keychain.files)
    }
  '';
  fileType = types.submodule ({ config, ... }: {
    options = {
      source = mkOption {
        type = types.either types.path types.str;
      };
      sourceFile = mkOption {
        type = types.path;
        default = asStoreFile "data" config.source;
      };
      owner = mkOption {
        type = types.str;
        default = if isNixos then "root" else config_.home.username;
      };
      group = mkOption {
        type = types.str;
        default = if isNixos then "root" else "users";
      };
      mode = mkOption {
        type = types.str;
        default = "0400";
      };

      path = mkOption {
        type = types.path;
        internal = true;
      };
    };

    config.path = "${cfg.root}/" + (last (splitString "/" config.sourceFile));
  });
  keyType = types.submodule ({ config, ... }: {
    options = {
      public = mkOption {
        type = types.either types.path types.str;
      };
      private = mkOption {
        type = types.either types.path types.str;
      };

      path = {
        public = mkOption {
          type = types.path;
          internal = true;
        };
        private = mkOption {
          type = types.path;
          internal = true;
        };
      };
    };

    config.path = {
      public = asStoreFile "id_rsa.pub" config.public;
      private = asFile "id_rsa" config.private;
    };
  });
in {
  options.keychain = {
    enable = mkOption {
      type = types.bool;
      default = cfg.files != { };
    };
    files = mkOption {
      type = types.attrsOf fileType;
      default = { };
    };
    keys = mkOption {
      type = types.attrsOf keyType;
      default = { };
    };
    root = mkOption {
      type = types.path;
      default = if isNixos
        then "/var/lib/arc/keychain"
        else "${config.xdg.cacheHome}/arc/keychain";
    };
  };

  config = if isNixos then mkIf cfg.enable {
    system.activationScripts.arc_keychain = {
      text = activationScript;
      deps = [ ];
    };
  } else mkIf cfg.enable {
    home.activation.arc_keychain = config.lib.dag.entryAfter ["writeBoundary"] activationScript;
  };
}
