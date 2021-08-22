{ pkgs, lib, config, ... }: let
  cfg = config.services.konawall;
  arc = import ../../canon.nix { inherit pkgs; };
  service = config.systemd.user.services.konawall;
in with lib; {
  options.services.konawall = {
    enable = mkEnableOption "enable konawall";
    mode = mkOption {
      type = types.str;
      default = "random";
    };
    commonTags = mkOption {
      type = types.listOf types.str;
      default = ["score:>=200" "width:>=1600"];
    };
    tags = mkOption {
      type = types.listOf types.str;
      default = ["nobody"];
    };
    tagList = mkOption {
      type = types.listOf (types.listOf types.str);
      default = singleton cfg.tags;
    };
    package = mkOption {
      type = types.package;
      default = pkgs.konawall or arc.packages.konawall;
    };
    interval = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "20m";
      description = "How often to rotate backgrounds (specify as a systemd interval)";
    };
  };

  config.systemd.user = mkIf cfg.enable {
    services = {
      konawall = {
        Unit = rec {
          Description = "Random wallpapers";
          After = mkMerge [
            [ "graphical-session-pre.target" ]
            (mkIf config.wayland.windowManager.sway.enable [ "sway-session.target" ])
          ];
          PartOf = mkMerge [
            [ "graphical-session.target" ]
            (mkIf config.wayland.windowManager.sway.enable [ "sway-session.target" ])
          ];
          Requisite = PartOf;
        };
        Service = {
          Type = "oneshot";
          Environment = [
            "PATH=${makeSearchPath "bin" (with pkgs; [ feh pkgs.xorg.xsetroot ])}"
          ];
          ExecStart = let
            tags = map (n: concatStringsSep "," n) cfg.tagList;
            tags-sep = concatStringsSep " " tags;
          in "${cfg.package}/bin/konawall --mode ${cfg.mode} ${if ((length cfg.commonTags) > 0) then ''--common ${concatStringsSep "," cfg.commonTags}'' else ""} ${tags-sep}";
          RemainAfterExit = true;
          IOSchedulingClass = "idle";
          TimeoutStartSec = "5m";
        };
        Install.WantedBy = mkMerge [
          (mkDefault [ "graphical-session.target" ])
          (mkIf config.wayland.windowManager.sway.enable [ "sway-session.target" ])
        ];
      };
      konawall-rotation = mkIf (cfg.interval != null) {
        Unit = {
          Description = "Random wallpaper rotation";
          inherit (service.Unit) Requisite;
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${config.systemd.package or pkgs.systemd}/bin/systemctl --user restart konawall";
        };
      };
    };
    timers.konawall-rotation = mkIf (cfg.interval != null) {
      Unit = {
        inherit (service.Unit) After PartOf;
      };
      Timer = {
        OnUnitInactiveSec = cfg.interval;
        OnStartupSec = cfg.interval;
      };
      Install = {
        inherit (service.Install) WantedBy;
      };
    };
  };
}
