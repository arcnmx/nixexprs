{ super, ... }:
let
  writeShellScriptBin = name: contents: let
    res = (super.writeShellScriptBin name contents).overrideAttrs (old: {
      passthru = (old.passthru or {}) // {
        exec = "${res}/bin/${name}";
      };
    });
  in res;
in
{
  inherit writeShellScriptBin;
}
