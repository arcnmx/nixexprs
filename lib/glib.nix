{ lib }: with lib; let
  gkeyvalue = k: v: ''"${k}": <${gvariant v}>'';
  gvariant = value:
    if value == true then "true"
    else if value == false then "false"
    else if value == null then "nothing"
    else if isString value then ''"${toString value}"''
    else if isList value then ''[${concatMapStringsSep ", " gvariant value}]''
    else if isAttrs value then "{" + concatStringsSep ", " (mapAttrsToList gkeyvalue value) + "}"
    else toString value;
  gvariantType = types.submodule ({ config, name, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
      };

      value = mkOption {
        type = with types; let
          primitives = [ (nullOr str) bool int float ];
          gvar = oneOf (primitives ++ [ (listOf gvar) (attrsOf gvar) ]);
          # tuples are distinct from arrays, also bytestrings exist, also variant arrays maybe?
        in gvar;
      };
    };
  });
in {
  inherit gvariantType;
}
