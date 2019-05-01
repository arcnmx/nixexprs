{ stdenvNoCC, fetchFromGitHub, makeWrapper, taskwarrior, jq }: with stdenvNoCC.lib; let
  package = stdenvNoCC.mkDerivation rec {
    name = "task-blocks";

    src = fetchFromGitHub {
      owner = "arcnmx";
      repo = name;
      rev = "e09c29f8482f02838a2eae24ff5253eb78af7993";
      sha256 = "1bgy0m0ggbx5jf7jq39gxfhwz87y4nyvczvsrcxb02blhl9s7ca4";
    };

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ taskwarrior jq ];

    makeFlags = ["TASKDATA=$(out)"];

    taskHooks = [ "on-exit" "on-add" "on-modify" ];
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
