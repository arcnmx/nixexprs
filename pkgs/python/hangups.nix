{ lib, pythonPackages, protobuf3_13 ? null, protobuf3_15 ? protobuf3_13 }:

with pythonPackages;

buildPythonPackage rec {
  pname = "hangups";
  version = "0.4.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15qbbafcrdkx73xz9y30qa3d8nj6mgrp2m41749i5nn1qywmikk8";
  };

  propagatedBuildInputs = [
    ConfigArgParse
    aiohttp
    async-timeout
    appdirs
    readlike
    requests
    reparser
    (protobuf.override {
      protobuf = protobuf3_15;
    })
    urwid
    (MechanicalSoup.overrideAttrs (old: rec {
      version = "0.12.0";
      src = fetchPypi {
        inherit version;
        inherit (old) pname;
        sha256 = "1g976rk79apz6rc338zq3ml2yps8hb88nyw3a698d0brm4khd9ir";
      };
    }))
  ];

  checkInputs = [
    httpretty
    pytest
    pytestrunner
    pytest-mock
    pytest-asyncio
  ];

  meta.broken = pythonOlder "3.6" || lib.isNixpkgsStable;
}
