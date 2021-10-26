{ stdenvNoCC, lua-amalg, fetchFromGitHub, lua5_4 ? lua5_3, lua5_3 }: stdenvNoCC.mkDerivation {
  pname = "wireplumber-scripts";
  version = "2021-10-26";

  src = fetchFromGitHub {
    owner = "arcnmx";
    repo = "wireplumber-scripts";
    rev = "3ff6e735e08cf84add9230f6a129391db1984926";
    sha256 = "17bhpyjw42c7y8237mf1r3z5lsczax3i7sdsiv93nv5ic35ch6g2";
  };

  nativeBuildInputs = [ lua-amalg ];
  checkInputs = [ lua5_4 ];

  installFlags = [ "INSTALLDIR=${placeholder "out"}" ];
}
