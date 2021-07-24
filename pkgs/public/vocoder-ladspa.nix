{ stdenv, fetchzip, ladspaH }: stdenv.mkDerivation rec {
  pname = "vocoder-ladspa";
  version = "0.4";

  src = fetchzip {
    url = "https://www.sirlab.de/linux/download/${pname}-${version}.tgz";
    sha256 = "1ivyqyplni8mc81crk6py8k82nqhqxir70gikkf4c1am1zyqb2fq";
  };

  buildInputs = [ ladspaH ];

  installFlags = [ "INSTALL_PLUGINS_DIR=$(out)/lib/ladspa" ];
}
