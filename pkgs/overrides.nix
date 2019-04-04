{ callPackage }: let
  packages = {
    pass-otp = { pass }: pass.withExtensions (ext: [ext.pass-otp]);
    xdg_utils-mimi = { xdg_utils }: xdg_utils.override { mimiSupport = true; };
    luakit-develop = { fetchFromGitHub, luakit }: luakit.overrideAttrs (old: rec {
      name = "luakit-${version}";
      version = "c6b5a031a50daf757cd1d24535bbf5f88de79434";
      src = fetchFromGitHub {
        owner = "luakit";
        repo = "luakit";
        rev = "${version}";
        sha256 = "024cnka5cg8cggr625cdpda3ynss4yffqfhvyhg0m8y8w43qk90c";
      };
    });

    # usbmuxd is old/broken
    usbmuxd = { fetchFromGitHub, usbmuxd }: usbmuxd.overrideAttrs(old: rec {
      version = "git";
      src = fetchFromGitHub {
        owner = "libimobiledevice";
        repo = "usbmuxd";
        rev = "b1b0bf390363fa36aff1bc09443ff751943b9c34";
        sha256 = "176hapckx98h4x0ni947qpkv2s95f8xfwz00wi2w7rgbr6cviwjq";
      };
    });
    libusbmuxd = { fetchFromGitHub, libusbmuxd }: libusbmuxd.overrideAttrs(old: rec {
      version = "git";
      src = fetchFromGitHub {
        owner = "libimobiledevice";
        repo = "libusbmuxd";
        rev = "c75605d862cd1c312494f6c715246febc26b2e05";
        sha256 = "0467a045k4znmaz61i7a2s7yywj67q830ja6zn7z39k5pqcl2z4p";
      };
    });
    libimobiledevice = { fetchFromGitHub, libimobiledevice }: libimobiledevice.overrideAttrs(old: rec {
      version = "git";
      src = fetchFromGitHub {
        owner = "libimobiledevice";
        repo = "libimobiledevice";
        rev = "0584aa90c93ff6ce46927b8d67887cb987ab9545";
        sha256 = "0rvj0aw9m44z457qnjmsp72bvflc0zvlmd3z98mpgli93pvf6cz9";
      };
    });
  };
in {
  overrides = callPackage packages { };
  override = packages;
}
