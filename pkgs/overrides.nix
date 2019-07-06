let
  packages = {
    pass-otp = { pass, hostPlatform, pass-otp ? null }: (pass.withExtensions (ext: [ext.pass-otp])).overrideAttrs (old: {
      doInstallCheck = !hostPlatform.isDarwin;
    });

    vim_configurable-pynvim = { vim_configurable, python3 }: vim_configurable.override {
      # vim with python3
      python = python3.withPackages(ps: with ps; [ pynvim ]);
      wrapPythonDrv = true;
      guiSupport = "no";
      luaSupport = false;
      multibyteSupport = true;
      ftNixSupport = false; # provided by "vim-nix" plugin
      # TODO: fully disable X11?
    };

    rxvt_unicode-cvs = { rxvt_unicode, fetchcvs }: rxvt_unicode.overrideAttrs (old: {
      enableParallelBuilding = true;
      src = fetchcvs {
        cvsRoot = ":pserver:anonymous@cvs.schmorp.de:/schmorpforge";
        module = "rxvt-unicode";
        date = "2019-07-01";
        sha256 = "04vgrri1zm5kgjdd4swfi4khjbbp8a3s5c46by7lqg417xqh2a5m";
      };
    });
    rxvt_unicode-arc = { rxvt_unicode-with-plugins, rxvt_unicode-cvs, pkgs }: rxvt_unicode-with-plugins.override {
      rxvt_unicode = rxvt_unicode-cvs; # current release is years old, doesn't include 24bit colour changes
      plugins = with pkgs; [
        urxvt_perl
        urxvt_perls
        #urxvt_font_size ?
        urxvt_theme_switch
        urxvt_vtwheel
        urxvt_osc_52
      ];
    };

    xdg_utils-mimi = { xdg_utils }: xdg_utils.override { mimiSupport = true; };

    luakit-develop = { fetchFromGitHub, luakit }: luakit.overrideAttrs (old: rec {
      name = "luakit-${version}";
      version = "6f809182e0c0b9709cec3a01f31ff8ec77dce997";
      src = fetchFromGitHub {
        owner = "luakit";
        repo = "luakit";
        rev = "${version}";
        sha256 = "1vn1i9ak7c7j3fk8b241rf88h2qfj3hrm0kyv6rhdj2yya8zdcnb";
      };
    });

    electrum-cli = { electrum }: electrum.overrideAttrs (old: {
      pname = "electrum-cli";
      propagatedBuildInputs = builtins.filter (p: (p.pname or null) != "PyQt" && (p.pname or null) != "qdarkstyle") old.propagatedBuildInputs;
      postPatch = ''
        sed -i -e '/qdarkstyle/d' contrib/requirements/requirements.txt
      '';
      installCheckPhase = "true";
      doCheck = false;
      meta = with electrum.stdenv.lib; electrum.meta // {
        broken = electrum.stdenv.isDarwin && versionOlder version "19.09pre";
        platforms = platforms.all; # TODO: allow darwin on unstable once the channel updates
      };

      # darwin doesn't have to worry about share/applications/electrum.desktop silliness
      ${if electrum.stdenv.isLinux then null else "postInstall"} = "true";
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

    # usbmuxd is old/broken
    usbmuxd = { fetchFromGitHub, usbmuxd }: usbmuxd.overrideAttrs (old: rec {
      version = "git";
      src = fetchFromGitHub {
        owner = "libimobiledevice";
        repo = "usbmuxd";
        rev = "b1b0bf390363fa36aff1bc09443ff751943b9c34";
        sha256 = "176hapckx98h4x0ni947qpkv2s95f8xfwz00wi2w7rgbr6cviwjq";
      };
    });
    libusbmuxd = { fetchFromGitHub, libusbmuxd }: libusbmuxd.overrideAttrs (old: rec {
      version = "git";
      src = fetchFromGitHub {
        owner = "libimobiledevice";
        repo = "libusbmuxd";
        rev = "c75605d862cd1c312494f6c715246febc26b2e05";
        sha256 = "0467a045k4znmaz61i7a2s7yywj67q830ja6zn7z39k5pqcl2z4p";
      };
    });
    libimobiledevice = { fetchFromGitHub, libimobiledevice }: libimobiledevice.overrideAttrs (old: rec {
      version = "git";
      src = fetchFromGitHub {
        owner = "libimobiledevice";
        repo = "libimobiledevice";
        rev = "0584aa90c93ff6ce46927b8d67887cb987ab9545";
        sha256 = "0rvj0aw9m44z457qnjmsp72bvflc0zvlmd3z98mpgli93pvf6cz9";
      };
    });
    /*flashplayer-standalone = { flashplayer-standalone, fetchurl }: flashplayer-standalone.overrideAttrs (old: rec {
      name = "flashplayer-standalone-${version}";
      version = "32.0.0.207";
      src = fetchurl {
        url = "https://fpdownload.macromedia.com/pub/flashplayer/updaters/32/flash_player_sa_linux.x86_64.tar.gz";
        sha256 = "0d2pxggrzamrg143bvic0qa2v70jpplnahihfa4q2rbvy0l3i2pq";
      };
    });*/
  };
in packages // {
  instantiate = { self, super, ... }: let
    called = builtins.mapAttrs (name: p: let
        args = if super ? ${name} && (! super ? arc) # awkward if this gets overlaid twice..?
        then {
          ${name} = super.${name};
        } else { };
        # TODO: this messes with the original .override so use lib.callWith instead?
      in self.callPackage p args
    ) packages;
  in called;
}
