{ pkgs, lib, ... }: with lib; let
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
      public = pkgs.arc.lib.asFile "id_rsa.pub" config.public;
      private = pkgs.arc.lib.asFile "id_rsa" config.private;
    };
  });
in {
  options.keychain = {
    enable = mkOptionEnable "keychain";
    keys = mkOption {
      type = types.attrsOf keyType;
      default = { };
    };
  };
}
