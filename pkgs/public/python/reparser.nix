{ lib, python3, readlike }:

with python3.pkgs;

buildPythonPackage rec {
  pname = "ReParser";
  version = "1.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nniqb69xr0fv7ydlmrr877wyyjb61nlayka7xr08vlxl9caz776";
  };

  propagatedBuildInputs = [
    #enum34 if python version < 3.4?
  ];

  checkInputs = [
    pytest
    pytestrunner
    pytest-mock
    pytest-asyncio
  ];
}
