{ stdenvNoCC }: stdenvNoCC.mkDerivation {
  pname = "git-continue";
  version = "2021-12-11";

  src = ./git-continue.sh;

  unpackPhase = ''
    runHook preUnpack

    cp $src git-continue.sh

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -Dm0755 git-continue.sh $out/bin/git-continue

    runHook postInstall
  '';
}
