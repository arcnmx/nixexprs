{ lib, pythonPackages }:

with pythonPackages;

buildPythonPackage rec {
  pname = "svdtools";
  version = "0.1.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00shi243vi7zxhnlw28idx0xap4il2zkma08ms1ad1cclayl6asb";
  };

  propagatedBuildInputs = [
    pyyaml
    lxml
    click
  ];

  checkInputs = [
    pytest
    black
    flit
    isort
  ];

  meta.broken = python.isPy2;
}
