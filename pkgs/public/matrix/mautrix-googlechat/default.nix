{ fetchFromGitHub, fetchpatch, lib, python3Packages, e2be ? true, metrics ? false }: with python3Packages;

buildPythonApplication {
  pname = "mautrix-googlechat";
  version = "2022-02-16";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "googlechat";
    rev = "bafd1f7e0a016d7a68adaae833d87b10990ea6f3";
    sha256 = "1grdjxacnadhhmyrqkm9q6c11xdxjsmmpvf8l9rpx8nkyw98dj1z";
  };

  patches = [ ./entrypoint.patch ];

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

  meta.broken = lib.versionOlder mautrix.version "0.14.6";
  passthru = {
    pythonModule = python;
    pythonPackage = "mautrix_googlechat";
  };

  doCheck = false;
}
