{ fetchFromGitHub, buildZshPlugin, fetchpatch }: buildZshPlugin rec {
  pname = "zsh-tab-title";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "trystan2k";
    repo = pname;
    rev = "v${version}";
    sha256 = "137mfwx52cg97qy3xvvnp8j5jns6hi20r39agms54rrwqyr1918f";
  };

  patches = [ (fetchpatch {
    url = "https://github.com/arcnmx/zsh-tab-title/commit/273c4fa3be43687cf7202589aa11d1f5a3789b7f.patch";
    sha256 = "035wiljxych4nydxkvffcb1czrxrvbw1g13qvwfafycqgdfv8zww";
  }) ];
}
