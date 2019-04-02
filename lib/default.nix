{ super, lib }: lib.makeExtensible (self: let
  isPath = lib.types.path.check;
  asFile = name: strOrPath: if isPath strOrPath
    then strOrPath
    else builtins.toFile name strOrPath;
  update = a: b: a // b;
  attrNameValues = lib.mapAttrsToList lib.nameValuePair;
  foldAttrs = lib.foldl update {};
  foldAttrsRecursive = lib.foldl lib.updateRecursive {};
  moduleValue = config: builtins.removeAttrs config ["_module"];
  callLibs = file: import file { inherit lib self super; };
  copyFunctionArgs = src: dst: lib.setFunctionArgs dst (lib.functionArgs src);
  callFunctionAs = callPackage: fn: args: let
    res = callPackage fn args;
  in if lib.isFunction fn || (!lib.isAttrs fn && isPath fn) then
    (if lib.isFunction res
      then callFunctionAs callPackage res args
      else res)
    else if lib.isAttrs fn then
      lib.mapAttrs (_: p: callFunctionAs callPackage p args) fn
    else builtins.trace fn throw "expected package function";
  isRust2018 = rustPlatform: let
    major = lib.versions.major rustPlatform.rust.cargo.version;
    minor = lib.versions.minor rustPlatform.rust.cargo.version;
  in lib.toInt major == 1 && lib.toInt minor >= 31;
  build-support = callLibs ./build-support;
in {
  inherit
    copyFunctionArgs callFunctionAs
    isPath asFile
    update attrNameValues moduleValue
    foldAttrs foldAttrsRecursive
    isRust2018
    build-support;
})
