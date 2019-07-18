{ buildGoModule, fetchFromGitHub }: buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "2019-07-04";
  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "29f5ae45c4b22f463003b23e355b951831f08b3e";
    sha256 = "12209m3x01i7bnnkg57ag1ivsk6n6pqaqfin7y02irgi3i3rm31r";
  };

  modSha256 = "151b4xxzj8z1avq3d7p1vyvr3lh1fk130clpf59ahxrgycklrif1";
}
