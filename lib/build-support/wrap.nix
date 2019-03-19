{ self, ... }:
let
  wrapShellScriptBin = name: src: {
    stdenvNoCC, makeWrapper, bash, lib,
    depsRuntimePath ? [], buildInputs ? [],
    ...
  } @env: let
    env' = builtins.removeAttrs env ["stdenvNoCC" "makeWrapper" "lib" "bash" "depsRuntimePath" "buildInputs"];
    pkg = stdenvNoCC.mkDerivation ({
      inherit name src;
      source = src;
      nativeBuildInputs = [bash makeWrapper];
      buildInputs = buildInputs ++ depsRuntimePath;
      shouldWrap = if builtins.length depsRuntimePath > 0 then "true" else "false";
      wrapperPath = lib.makeBinPath depsRuntimePath;
      configurePhase = "true";
      buildPhase = "true";
      unpackPhase = "true";
      installPhase = ''
        install -Dm0755 $source $out/bin/$name
        if $shouldWrap; then
          wrapProgram $out/bin/$name --prefix PATH : $wrapperPath
        fi
      '';
      checkPhase = ''
        if [[ -f $out/bin/.$name-wrapped ]]; then
          bash -n $out/bin/.$name-wrapped
        fi
        bash -n $out/bin/$name
      '';
      passthru = {
        exec = "${pkg}/bin/${name}";
      };
    } // env');
  in
  pkg;
  substituteShellScriptBin = name: src: self.copyFunctionArgs (wrapShellScriptBin null null) (env:
    wrapShellScriptBin name src ({
      source = "${name}.sub";
      buildPhase = ''
        substituteAll $src $source
      '';
    } // env));
  substituteFile = name: src: { stdenvNoCC, lib } @env: let
    env' = builtins.removeAttrs env ["stdenvNoCC" "lib"];
    pkg = stdenvNoCC.mkDerivation ({
      inherit name src;
      configurePhase = "true";
      buildPhase = ''
        substituteAll $src $name
      '';
      unpackPhase = "true";
      installPhase = ''
        install -Dm0644 $name $out
      '';
      checkPhase = "true";
    } // env');
    in
    pkg;
in
{
  inherit wrapShellScriptBin substituteShellScriptBin substituteFile;
}
