{ fetchFromGitHub, rustPlatform, hostPlatform, pkg-config, gstreamer ? gst_all_1.gstreamer, gst_all_1 ? null }: rustPlatform.buildRustPackage rec {
  pname = "gst-protectbuffer";
  version = "2021-07-23";

  src = fetchFromGitHub {
    owner = "arcnmx";
    repo = pname;
    rev = "249cf36dcb412f44d8c4f47a0d3b5b5277235455";
    sha256 = "11fc38mkqffrh1ykyahzf2wjycq2502f6iabgmq6mrnmk4rx25mz";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gstreamer ];

  cargoHash = "sha256-Yvo5FYZLbasy4m/wS6kJHqVxthY+8z+1s+4bVhqkwI8=";

  libname = "libgstprotectbuffer" + hostPlatform.extensions.sharedLibrary;
  postInstall = ''
    mkdir -p $out/lib/gstreamer-1.0
    mv $out/lib/$libname $out/lib/gstreamer-1.0/
  '';
}
