{ callPackage }: let
  packages = {
    pass-otp = { pass, hostPlatform }: (pass.withExtensions (ext: [ext.pass-otp])).overrideAttrs (old: {
      doInstallCheck = !hostPlatform.isDarwin;
    });
    xdg_utils-mimi = { xdg_utils }: xdg_utils.override { mimiSupport = true; };
    luakit-develop = { fetchFromGitHub, luakit }: luakit.overrideAttrs (old: rec {
      name = "luakit-${version}";
      version = "b24e6d46e5e79f4a9c280a5dcf2118c1847a1019";
      src = fetchFromGitHub {
        owner = "luakit";
        repo = "luakit";
        rev = "${version}";
        sha256 = "0pyyy7ibd5csxvbkf2q4dripykd0xqgsricslafgv13j4fvm0zm7";
      };
    });
    electrum-cli = { electrum, lib }: electrum.overrideAttrs (old: {
      propagatedBuildInputs = builtins.filter (p: (p.pname or null) != "PyQt" && (p.pname or null) != "qdarkstyle") old.propagatedBuildInputs;
      postPatch = ''
        sed -i -e '/qdarkstyle/d' contrib/requirements/requirements.txt
      '';
      installCheckPhase = "true";
      doCheck = false;
      meta.broken = lib.versionAtLeast lib.version "19.09pre";
    });
    passff-host = { fetchFromGitHub, passff-host, pass }: (passff-host.override { inherit pass; }).overrideAttrs (old: rec {
      pname = "passff-host";
      version = "1.2.1";
      name = "${pname}-${version}";

      src = fetchFromGitHub {
        owner = "passff";
        repo = pname;
        rev = version;
        sha256 = "0ydfwvhgnw5c3ydx2gn5d7ys9g7cxlck57vfddpv6ix890v21451";
      };

      nativeMessagingPaths = [
        "lib/mozilla/native-messaging-hosts"
      ];

      preBuild = "";
      postBuild = "";

      installPhase = old.installPhase + ''
        for messagingDir in $nativeMessagingPaths; do
          install -Dm0644 -t $out/$messagingDir $out/share/$pname/passff.json
        done
      '';
    });
    acpilight = { acpilight }: acpilight.overrideAttrs (old: {
      postConfigure = ''
        ${old.postConfigure}
        substituteInPlace Makefile --replace udevadm true
      '';
    });

    # usbmuxd is old/broken
    usbmuxd = { fetchFromGitHub, usbmuxd, libimobiledevice }: (usbmuxd.overrideAttrs (old: rec {
      version = "git";
      src = fetchFromGitHub {
        owner = "libimobiledevice";
        repo = "usbmuxd";
        rev = "b1b0bf390363fa36aff1bc09443ff751943b9c34";
        sha256 = "176hapckx98h4x0ni947qpkv2s95f8xfwz00wi2w7rgbr6cviwjq";
      };
    })).override { inherit libimobiledevice; };
    libusbmuxd = { fetchFromGitHub, libusbmuxd }: (libusbmuxd.overrideAttrs (old: rec {
      version = "git";
      src = fetchFromGitHub {
        owner = "libimobiledevice";
        repo = "libusbmuxd";
        rev = "c75605d862cd1c312494f6c715246febc26b2e05";
        sha256 = "0467a045k4znmaz61i7a2s7yywj67q830ja6zn7z39k5pqcl2z4p";
      };
    }));
    libimobiledevice = { fetchFromGitHub, libimobiledevice, libusbmuxd }: (libimobiledevice.overrideAttrs (old: rec {
      version = "git";
      src = fetchFromGitHub {
        owner = "libimobiledevice";
        repo = "libimobiledevice";
        rev = "0584aa90c93ff6ce46927b8d67887cb987ab9545";
        sha256 = "0rvj0aw9m44z457qnjmsp72bvflc0zvlmd3z98mpgli93pvf6cz9";
      };
    })).override { inherit libusbmuxd; };
    flashplayer-standalone = { flashplayer-standalone }: flashplayer-standalone;
    /*flashplayer-standalone = { flashplayer-standalone, fetchurl }: flashplayer-standalone.overrideAttrs (old: rec {
      name = "flashplayer-standalone-${version}";
      version = "32.0.0.207";
      src = fetchurl {
        url = "https://fpdownload.macromedia.com/pub/flashplayer/updaters/32/flash_player_sa_linux.x86_64.tar.gz";
        sha256 = "0d2pxggrzamrg143bvic0qa2v70jpplnahihfa4q2rbvy0l3i2pq";
      };
    });*/
  };
  overrides = callPackage packages { };
in {
  overrides = overrides // rec {
    libimobiledevice = overrides.libimobiledevice.override { inherit (overrides) libusbmuxd; };
    usbmuxd = overrides.usbmuxd.override { inherit libimobiledevice; };
  };
  override = packages;
}
