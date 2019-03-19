{ pkgs, lib, config, ... }: let
  cfg = config.programs.mpv;
in with lib; {
  options.programs.mpv = {
    enable = mkEnableOption "enable mpv configuration";
    extraConfig = mkOption {
      type = types.attrsOf types.str;
      description = "default command-line options";
      example = { hwdec = "auto"; };
      default = {};
    };

    package = mkOption {
      type = types.nullOr types.package;
      default = pkgs.mpv;
      defaultText = "pkgs.mpv";
      description = ''
        mpv package to add to user environment.
      '';
    };
  };

  config.xdg.configFile = mkIf cfg.enable {
    # TODO: all other mpv config files
    "mpv/mpv.conf".text = ''
      # vim: syntax=config
      ${concatStringsSep "\n" (mapAttrsToList (k: v: "${k}=${v}") cfg.extraConfig)}
    '';
  };

  config.home.packages = mkIf (cfg.package != null) [cfg.package];
}
