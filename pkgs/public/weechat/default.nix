{
  weechat-matrix = { python3Packages, fetchFromGitHub }: with python3Packages; buildPythonApplication rec {
    pname = "weechat-matrix";
    version = "2021-05-01";

    src = fetchFromGitHub {
      owner = "poljar";
      repo = "weechat-matrix";
      rev = "0d491bd3a61d660e7c6addf492bed76361195679";
      sha256 = "13bgsa92g3xkw5mg4zrgmp0f9b7a6yyphvjjhvq6ch6agxr84sdp";
    };

    propagatedBuildInputs = [ requests matrix-nio ];

    doCheck = false;

    passAsFile = [ "setup" ];
    setup = ''
      from setuptools import setup

      setup(
        name='@pname@',
        version='@version@',
        install_requires=['requests', 'matrix-nio'],
        scripts=['contrib/matrix_decrypt.py'],
      )
    '';

    postPatch = ''
      substituteAll $setupPath setup.py
    '';

    postInstall = ''
      mv $out/bin/matrix_decrypt{.py,}

      install -D main.py $out/share/weechat/matrix.py
    '';

    passthru = {
      scripts = [ "weechat/matrix.py" ];
      pythonPath = weechat-matrix;
    };
  };
}
