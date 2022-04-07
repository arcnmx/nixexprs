{ lib, pkgs, config, ... }: with lib; let
  cfg = config.services.matrix-synapse.appservices;
  inherit (import ./matrix-common.nix { inherit lib pkgs; }) registrationModule;
  arc = import ../../canon.nix { inherit pkgs; };
  isNixpkgsStable = lib.isNixpkgsStable or arc.lib.isNixpkgsStable;
  appservices = attrValues cfg;
  enabledAppservices = filter (cfg: cfg.enable) appservices;
  localAppservices = filterAttrs (_: appservice: appservice.enable) config.services.matrix-appservices or { };
  enable = cfg != { };
  appserviceModule = { name, ... }: {
    imports = [ registrationModule ];
    options = {
      enable = mkEnableOption "appservice ${name}" // {
        default = true;
      };
    };
    config = {
      configuration = {
        name = "matrix-synapse-${name}";
        combinedPath = "/run/matrix-synapse/${name}.yaml";
      };
    };
  };
  appserviceType = types.submodule appserviceModule;
in {
  options.services.matrix-synapse.appservices = mkOption {
    type = with types; attrsOf appserviceType;
    default = { };
  };
  config = {
    services.matrix-synapse = let
      app_service_config_files = mkIf enable (map (cfg: cfg.configuration.path) enabledAppservices);
    in {
      appservices = mapAttrs (_: appservice: appservice.registration.set) localAppservices;
    } // (if isNixpkgsStable then {
      inherit app_service_config_files;
    } else {
      settings = {
        inherit app_service_config_files;
      };
    });
    systemd.services.matrix-synapse = mkIf (config.services.matrix-synapse.enable && enable) {
      serviceConfig = {
        RuntimeDirectory = [ "matrix-synapse" ];
      };
      preStart = mkMerge (map (appservice: ''
        ${appservice.configuration.out.generate}
      '') enabledAppservices);
    };
  };
}
