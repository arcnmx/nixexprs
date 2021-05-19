{
  weechat-matrix-contrib = { python3Packages, fetchFromGitHub }: with python3Packages; buildPythonApplication rec {
    pname = "weechat-matrix-contrib";
    version = "2021-05-01";

    src = fetchFromGitHub {
      owner = "poljar";
      repo = "weechat-matrix";
      rev = "0d491bd3a61d660e7c6addf492bed76361195679";
      sha256 = "13bgsa92g3xkw5mg4zrgmp0f9b7a6yyphvjjhvq6ch6agxr84sdp";
    };

    propagatedBuildInputs = [ python_magic requests matrix-nio aiohttp ];

    format = "other";

    postPatch = ''
      substituteInPlace contrib/matrix_upload.py \
        --replace "env -S " ""
      substituteInPlace contrib/matrix_sso_helper.py \
        --replace "env -S " ""
    '';

    buildPhase = "true";
    installPhase = ''
      install -Dm0755 contrib/matrix_upload.py $out/bin/matrix_upload
      install -Dm0755 contrib/matrix_decrypt.py $out/bin/matrix_decrypt
      install -Dm0755 contrib/matrix_sso_helper.py $out/bin/matrix_sso_helper
    '';
  };
}
