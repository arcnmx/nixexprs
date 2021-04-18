{
  weechat-matrix-contrib = { python3Packages, fetchFromGitHub }: with python3Packages; buildPythonApplication rec {
    pname = "weechat-matrix-contrib";
    version = "2021-02-18";

    src = fetchFromGitHub {
      owner = "poljar";
      repo = pname;
      rev = "ef09292005d67708511a44c8285df1342ab66bd1";
      sha256 = "0rjfmzj5mp4b1kbxi61z6k46mrpybxhbqh6a9zm9lv2ip3z6bhlw";
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
