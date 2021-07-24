{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkg-config, gst_all_1 ? null, gstreamer ? gst_all_1.gstreamer, gst-plugins-base ? gst_all_1.gst-plugins-base }: stdenv.mkDerivation rec {
  pname = "gst-plugin-cedar";
  version = "2020-10-09";
  src = fetchFromGitHub {
    owner = "gtalusan";
    repo = pname;
    rev = "2d31203075fd79e3845309037665604f28b286c0";
    sha256 = "0qznfsxclgr0g6vz22fnc3f6djp9i936c0dfdyiy40rh82r4z4jj";
  };

  /*patches = [
    (fetchpatch {
      url = "https://github.com/mzakharo/gst-plugin-cedar/commit/eb70fe5a31f8516fde96f67a3a5c262bdffca6cd.patch";
      sha256 = "0w2jkr64liqhjbzpvzs1ysipwm4699kl5wm1g4bfvmx3rkb4i4if";
    })
    (fetchpatch {
      url = "https://github.com/mzakharo/gst-plugin-cedar/commit/d76600cec7ad77d1266ef628e193c0c0d1fa885d.patch";
      sha256 = "0qsa6wkjxjgxdgbiwqwrk4x4p7dv1570r8y1rq1i4n7y00v364l1";
    })
    (fetchpatch {
      url = "https://github.com/mzakharo/gst-plugin-cedar/commit/723d652058a379ce26b5dce5bc73bcc854be258b.patch";
      sha256 = "0y1rfh5ppawk8b147ddmzl71gh3yrra8697a1n2d6l63mk0qddi0";
    })
  ];*/

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ gstreamer gst-plugins-base ];

  #meta.platforms = lib.platforms.arm;
}
