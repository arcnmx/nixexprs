{ stdenvNoCC, fetchFromGitHub }: stdenvNoCC.mkDerivation rec {
  pname = "git-continue";
  version = "2021-12-11";

  src = fetchFromGitHub {
    owner = "arcnmx";
    repo = pname;
    rev = "f672a4edbacc129c97d5e9cafb3a562fee7ddd6a";
    sha256 = "1vap78ncg9n0v6lbdc661115y68llga3a1ja5csbnq206y6950i4";
  };

  installPhase = ''
    runHook preInstall

    install -Dm0755 git-continue.sh $out/bin/git-continue

    runHook postInstall
  '';
}
