self: super: let
  arc = import ../default.nix { pkgs = self; };
  overrides = arc.packages.select.overrides;
in {
  # TODO: move this into profiles, which should be able to modify nixpkgs.overlays?
  inherit (overrides) pass-otp xdg_utils-mimi luakit-develop;
  flashplayer-standalone = super.callPackage overrides.override.flashplayer-standalone { inherit (super) flashplayer-standalone; };

  # fix broken usbmuxd
  usbmuxd = super.callPackage overrides.override.usbmuxd { inherit (super) usbmuxd; };
  libusbmuxd = super.callPackage overrides.override.libusbmuxd { inherit (super) libusbmuxd; };
  libimobiledevice = super.callPackage overrides.override.libimobiledevice { inherit (super) libimobiledevice; };
}
