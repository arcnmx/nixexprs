{ lib, pythonPackages, git
, enableOlm ? !pythonPackages.python.stdenv.isDarwin
, hostPlatform
, fetchFromGitHub
}:

with pythonPackages;

buildPythonPackage rec {
  pname = "nio";
  version = "0.18.1";

  src = fetchPypi {
    pname = "matrix-nio";
    inherit version;
    sha256 = "040z9nah6akavvnixxzfhlbvhpixsq0pk6xc1k4sz18gzbpnv67i";
  };

  postPatch = lib.optionalString (!enableOlm) ''
    substituteInPlace setup.py \
      --replace 'python-olm>=3.1.0' ""
  '';

  doCheck = enableOlm;

  propagatedBuildInputs = [
    attrs
    future
    h11
    h2
    pycryptodome
    Logbook
    jsonschema
    unpaddedbase64
    aiohttp
    aiofiles
    aiohttp-socks
  ] ++ lib.optional (pythonOlder "3.7") dataclasses
  ++ lib.optionals enableOlm [ olm peewee atomicwrites cachetools ];

  meta.broken = python.isPy2 || lib.isNixpkgsStable;
  passthru = {
    inherit enableOlm;
  };
}
