{ arc }: with arc.super.lib; let
  overrides = [
    {
      attr = "notmuch";
      withAttr = "notmuch-arc";
      superAttr = "nixpkgsNotmuch";
      fallback = { ... }: arc.packages.groups.customized.notmuch-arc;
    }
    {
      attr = "ncpamixer";
      superAttr = "nixpkgsNcpamixer";
      apply = { previous, self, ... }: let
        segfaultLoopback = self.fetchpatch {
          url = "https://github.com/fulhax/ncpamixer/pull/49.diff";
          sha256 = "0bnh9xii3j7kvj46hwl87y6fa4x6mi7q7p2fd0rg814i0s9b682s";
        };
      in if previous.version == "1.3.3.1" then previous.overrideAttrs (old: {
        patches = old.patches or [] ++ [ segfaultLoopback ];
        enableParallelBuilding = true;
        buildPhase = null;
      }) else previous;
    }
    {
      attr = "cargo-expand";
      apply = { previous, self, ... }: previous.overrideAttrs (old: {
        meta = old.meta or { } // {
          broken = old.meta.broken or self.hostPlatform.isDarwin;
        };
      });
    }
    {
      attr = "mpd_clientlib";
      withAttr = "mpd_clientlib-buffer";
      superAttr = "nixpkgsMpd_clientlib";
      fallback = { ... }: arc.packages.groups.customized.mpd_clientlib-buffer;
    }

    # TODO: make tests that assert given (uncustomized) packages are still broken
  ];
in mapListToAttrs (o: nameValuePair o.attr o) overrides
