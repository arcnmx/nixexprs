{ stdenvNoCC, fetchFromGitHub, makeWrapper, python3, pass }: let
in stdenvNoCC.mkDerivation rec {
  pname = "tridactyl";
  version = "1.14.9";
  src = fetchFromGitHub {
    owner = "tridactyl";
    repo = pname;
    rev = version;
    sha256 = "0d80c744qfv6jd03cmdp3p71xaj8lq8jzsa2m24jxv9q4ks2dcmj";
  };

  nativeMessagingPaths = [
    "lib/mozilla/native-messaging-hosts"
  ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];

  wrapperPath = stdenvNoCC.lib.makeBinPath [ pass ];

  configurePhase = "true";
  buildPhase = ''
    sed -i -e "s,REPLACE_ME_WITH_SED,$out/lib/$pname/native_main.py," native/tridactyl.json
  '';
  installPhase = ''
    install -Dm0755 -t $out/lib/$pname native/native_main.py
    wrapProgram $out/lib/$pname/native_main.py --prefix PATH : $wrapperPath

    install -Dm0644 -t $out/lib/$pname native/tridactyl.json
    for messagingDir in $nativeMessagingPaths; do
      install -Dm0644 -t $out/$messagingDir native/tridactyl.json
    done
  '';
}
