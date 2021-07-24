{ lib, buildGoModule, fetchFromGitHub, wrapGAppsHook, pkg-config, libusb1, webkitgtk }:

buildGoModule rec {
  pname = "wally";
  version = "2.0.0";

  goPackagePath = "github.com/zsa/wally";
  subPackages = [ "." ];

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];

  buildInputs = [ libusb1 webkitgtk ];

  src = fetchFromGitHub {
    owner = "zsa";
    repo = "wally";
    rev = "${version}-linux";
    sha256 = "0jgn7rh8013rwjasmrvd29gba7n938yyp612ci6cy2f0kk6f4diw";
  };

  vendorSha256 = "0678mri6fk1mhnssnjn2jwy8wmzfrss5dkqf0wi1mdhbnjfz7v5s";

  # TODO: depend on wally-frontend, built by node react stuff :(

  outputs = [ "out" "udev" ];
  postInstall = ''
    install -Dm0644 -t $udev/lib/udev/rules.d dist/linux64/{50-oryx,50-wally}.rules

    substituteInPlace dist/linux64/wally.desktop \
      --replace Exec= Exec=$out/bin/
    install -Dm0644 -t $out/share/applications wally.desktop
    install -Dm0644 appicon.png $out/share/icons/hicolor/256x256/apps/wally.png
  '';

  # Can be removed when https://github.com/zsa/wally-cli/pull/1 is merged.
  doCheck = false;

  meta = with lib; {
    description = "A tool to flash firmware to mechanical keyboards";
    homepage = "https://ergodox-ez.com/pages/wally-planck";
    license = licenses.mit;
    maintainers = [ maintainers.arc ];
  };
}
