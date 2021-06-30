{ lib, pythonPackages }:

with pythonPackages;

buildPythonPackage rec {
  pname = "svdtools";
  version = "0.1.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1llkhryk20h16q80wdp7csi1fp60xkjv28vdi4zlsi4k233anz9v";
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
