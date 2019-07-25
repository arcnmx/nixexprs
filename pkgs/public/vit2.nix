{ fetchFromGitHub
, python3
, tasklib
, makeWrapper
, taskwarrior }:

with python3.pkgs;

buildPythonPackage rec {
  pname = "vit";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "scottkosty";
    repo = pname;
    rev = "2f06276671f11393b6faea9c6b6799536e76ca14";
    #rev = "v${version}";
    sha256 = "0gr19l6vx717g5n2clrlfl4idzbbz6b1gcq5a4b4j2xgkjcjc4f2";
  };

  propagatedBuildInputs = [
    pytz
    tasklib
    tzlocal
    urwid
  ];

  nativeBuildInputs = [ makeWrapper ];

  inherit taskwarrior;
  postInstall = ''
    wrapProgram $out/bin/vit --prefix PATH : $taskwarrior/bin
  '';

  preCheck = ''
    export TERM=linux
  '';
}
