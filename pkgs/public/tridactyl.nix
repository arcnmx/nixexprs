{ stdenvNoCC, fetchFromGitHub, makeWrapper, python3 }: let
in stdenvNoCC.mkDerivation rec {
  pname = "tridactyl";
  version = "1.15.0";
  src = fetchFromGitHub {
    owner = "tridactyl";
    repo = pname;
    rev = version;
    sha256 = "12pq95pw5g777kpgad04n9az1fl8y0x1vismz81mqqij3jr5qwzb";
  };

  nativeMessagingPaths = [
    "lib/mozilla/native-messaging-hosts"
  ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];

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
