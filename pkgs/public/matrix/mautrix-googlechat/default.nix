{ fetchFromGitHub, fetchpatch, lib, python3Packages, e2be ? true, metrics ? false }: with python3Packages; let

  mautrix = python3Packages.mautrix.overridePythonAttrs (old: rec {
    version = "0.16.11";
    src = old.src.override {
      inherit version;
      sha256 = "sha256-gwc+GxSAZBL0de3OXQb2haNAuFykE8qk0pFTDIYJWEk=";
    };
  });

in buildPythonApplication rec {
  pname = "mautrix-googlechat";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "googlechat";
    rev = "v${version}";
    sha256 = "sha256-cQEHDZht44f2YFTXIfS/NvV+raeZ8bZ0jPVQK+0RlJI=";
  };

  patches = [ ./entrypoint.patch ];

  postPatch = ''
    sed -i -e 's/asyncpg>=.*/asyncpg/' requirements.txt
  '';

  propagatedBuildInputs = [
    aiohttp
    yarl
    asyncpg
    ruamel_yaml
    CommonMark
    python_magic
    protobuf
    mautrix
    setuptools
  ] ++ lib.optionals e2be [
    python-olm
    pycryptodome
    unpaddedbase64
  ] ++ lib.optionals metrics [
    prometheus_client
  ];

  meta.broken = lib.versionOlder mautrix.version "0.16.6";
  passthru = {
    pythonModule = python;
    pythonPackage = "mautrix_googlechat";
  };

  doCheck = false;
}
