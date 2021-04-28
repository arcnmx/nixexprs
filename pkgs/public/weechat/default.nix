{
  weechat-matrix-contrib = { python3Packages, fetchFromGitHub }: with python3Packages; buildPythonApplication rec {
    pname = "weechat-matrix-contrib";
    version = "2021-04-21";

    src = fetchFromGitHub {
      owner = "poljar";
      repo = "weechat-matrix";
      rev = "2b668080bd2e5e7cb87266a0463017e7871c1df3";
      sha256 = "15wndg7mlfzmiq45xg1n13v7w6fsx8c9rgxh3qs82b372y2cmjh4";
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
