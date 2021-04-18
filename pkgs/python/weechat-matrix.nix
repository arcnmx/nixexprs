{ lib, pythonPackages, weechat-matrix-contrib }:

with pythonPackages;

buildPythonPackage rec {
  pname = "weechat-matrix";
  inherit (weechat-matrix-contrib) version src;

  propagatedBuildInputs = [
    pyopenssl
    webcolors
    atomicwrites
    attrs
    Logbook
    pygments
    requests
    python_magic
    matrix-nio
  ] ++ lib.optional (pythonOlder "3.5") typing
  ++ lib.optional (pythonOlder "3.2") future
  ++ lib.optional (pythonAtLeast "3.5") aiohttp;

  passAsFile = [ "setup" ];
  setup = ''
    from io import open
    from setuptools import find_packages, setup

    with open('requirements.txt') as f:
      requirements = f.read().splitlines()

    setup(
      name='@name@',
      version='@version@',
      install_requires=requirements,
      packages=find_packages(),
    )
  '';

  weechatMatrixContrib = weechat-matrix-contrib;
  postPatch = ''
    substituteInPlace matrix/uploads.py \
      --replace matrix_upload $weechatMatrixContrib/bin/matrix_upload
    substituteInPlace matrix/server.py \
      --replace matrix_sso_helper $weechatMatrixContrib/bin/matrix_sso_helper
    substituteAll $setupPath setup.py
  '' + lib.optionalString (!matrix-nio.enableOlm) ''
    substituteInPlace requirements.txt \
      --replace "[e2e]" ""
  '';

  meta.broken = ! weechat-matrix-contrib.meta.available or true;
}
