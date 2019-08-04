{ lib, pythonPackages, fetchFromGitHub, git }: pythonPackages.buildPythonPackage rec {
  pname = "nio";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "poljar";
    repo = "matrix-nio";
    rev = version;
    sha256 = "09kcqv5wjvxnx3ligql6k7h5rshsim97y356c9k01d9hpv1lbccb";
  };

  propagatedBuildInputs = with pythonPackages; [
    attrs
    future
    peewee
    h11
    h2
    atomicwrites
    pycryptodome
    sphinx
    Logbook
    jsonschema
    olm
    unpaddedbase64
  ] ++ lib.optional (!pythonPackages.python.isPy2) aiohttp;
}
