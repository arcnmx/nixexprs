{ lib
, path
, stdenv
, fetchFromGitLab
, fetchpatch
, fetchurl
, writeText
, runCommand
, substituteAll
, makeSetupHook
, buildPackages
, python3
, gobject-introspection
, x11Support ? stdenv.buildPlatform == stdenv.hostPlatform
, build_library_and_c_tools ? true
, build_python_tools ? true
, gi_cross_use_prebuilt_gi ? false
, build_introspection_data ?
    build_library_and_c_tools &&
    (build_python_tools || gi_cross_use_prebuilt_gi)
, gobject-introspection-py-tools ? null
}: let
  giSetupHook = makeSetupHook {
    name = "gobject-introspection-hook";
  } (runCommand "gobject-introspection-setup-hook.sh" {
    hook = path + "/pkgs/development/libraries/gobject-introspection/setup-hook.sh";
  } "sed -e s/hostOffset/targetOffset/ < $hook > $out");
  mkFlag = name: cond: "-D${name}=${if cond then "true" else "false"}";
  drv = gobject-introspection.override (old: {
    x11Support = old.x11Support or true && x11Support;
  });
in drv.overrideAttrs (old: {
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gobject-introspection";
    rev = "f9c1b6f65bec623d593835c400d2d55d981715c8";
    sha256 = "09mbxsrrfsi6hh8ixyxipnklcgi08scplqyvq3jwv74r5hy74h8w";
  };

  patches = old.patches or [ ] ++ [
    (fetchurl {
      url = "https://gitlab.gnome.org/GNOME/gobject-introspection/-/merge_requests/224.patch";
      sha256 = "0hd5ycgyn254512hvjyh3qm5la1508zw3zm1kaw5pdwb4izs77h4";
    })
    (substituteAll {
      name = "absolute-python-shebang.patch";
      src = fetchpatch {
        url = "https://github.com/NixOS/nixpkgs/raw/278bf51b70ccbc29114367cd15b273e8fdb22979/pkgs/development/libraries/gobject-introspection/absolute-python-shebang.patch";
        sha256 = "08fq30zsgx1kx11ix4qmrfdglpvh5w7rhsf8cwghp4mc99khb73f";
      };
      python_bin = lib.escapeShellArg python3.interpreter;
    })
  ];

  nativeBuildInputs = lib.filter (p: !lib.isPath p) old.nativeBuildInputs or [ ]
  ++ lib.optionals (build_introspection_data && !gi_cross_use_prebuilt_gi) [
    giSetupHook # move .gir files
  ] ++ lib.optionals gi_cross_use_prebuilt_gi [
    gobject-introspection-py-tools
  ];

  strictDeps = true;

  outputs = [ "out" ]
    ++ lib.optionals build_library_and_c_tools [ "dev" "devdoc" "bin" ]
    ++ [ "man" ];
  outputBin = if build_library_and_c_tools then "bin" else "out";

  mesonFlags = [
    "-Ddoctool=disabled"
    "-Dcairo=disabled"
    "-Dgtk_doc=true"
    (mkFlag "build_library_and_c_tools" build_library_and_c_tools)
    (mkFlag "build_python_tools" build_python_tools)
    (mkFlag "gi_cross_use_prebuilt_gi" gi_cross_use_prebuilt_gi)
    (mkFlag "build_introspection_data" build_introspection_data)
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    ("--cross-file=" + writeText "cross-file.conf" (''
      [binaries]
      exe_wrapper = ${lib.escapeShellArg (stdenv.hostPlatform.emulator buildPackages)}
    ''))
    "-Dgi_cross_ldd_wrapper=${buildPackages.prelink}/bin/prelink-rtld"
    "-Dgi_cross_binary_wrapper=${stdenv.hostPlatform.emulator buildPackages}"
  ] ++ lib.optional build_library_and_c_tools "--datadir=${placeholder "dev"}/share";

  postInstall = lib.optionalString build_library_and_c_tools ''
    sed -i '/bindir/d' "$out/lib/pkgconfig"/*.pc
  '';

  setupHook = null;
  propagatedBuildInputs = old.propagatedBuildInputs or [ ]
    ++ lib.optional build_python_tools giSetupHook;

  propagatedBuildOutputs = lib.optional build_library_and_c_tools "out";
})
