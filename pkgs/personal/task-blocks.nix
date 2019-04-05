{ stdenvNoCC, fetchFromGitHub, makeWrapper, taskwarrior, jq }: with stdenvNoCC.lib; let
  package = stdenvNoCC.mkDerivation rec {
    name = "task-blocks";

    src = fetchFromGitHub {
      owner = "arcnmx";
      repo = name;
      rev = "7b477629db13b67bc99a153d7acacccbfcb8944f";
      sha256 = "058bii4fgw6c83s9qna7qxzrn1dhk94b2q840shpw0hk3qswcnmv";
    };

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ taskwarrior jq ];

    makeFlags = ["TASKDATA=$(out)"];

    taskHooks = [ "on-exit" ];
    wrapperPath = makeBinPath buildInputs;
    preFixupPhases = ["wrapInstall"];
    wrapInstall = ''
      for f in $taskHooks; do
        wrapProgram $out/hooks/$f.$name --prefix PATH : $wrapperPath
      done
    '';

    passthru = listToAttrs (map (hook: nameValuePair hook "${package}/hooks/${hook}.${name}") taskHooks);
  };
in package
