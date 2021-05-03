{ config, pkgs, lib, ... }: with lib; let
  sessionStart = pkgs.writeShellScript "i3-session" ''
    set -eu
    ${config.systemd.package or pkgs.systemd}/bin/systemctl --user set-environment I3SOCK=$(${config.xsession.windowManager.i3.package}/bin/i3 --get-socketpath)
    ${config.systemd.package or pkgs.systemd}/bin/systemctl --user start graphical-session-i3.target
  '';
  inherit (config.xsession.windowManager.i3) enable;
in {
  config = mkIf enable {
    xsession.windowManager.i3.config.startup = [
      { command = "${sessionStart}"; notification = false; }
    ];
    systemd.user.targets.graphical-session-i3 = {
      Unit = {
        Description = "i3 X session";
        BindsTo = [ "graphical-session.target" ];
        Requisite = [ "graphical-session.target" ];
      };
    };
    systemd.user.services.polybar = mkIf (config.services.polybar.enable && enable) {
      Unit.After = [ "graphical-session-i3.target" ];
      Install.WantedBy = mkForce [ "graphical-session-i3.target" ];
    };
  };
}
