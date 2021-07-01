{
  substituteShellScriptBin, lib,
  coreutils, awscli2, curl ? null
}:
substituteShellScriptBin "filebin" ./filebin.sh {
  depsRuntimePath = [coreutils awscli2 curl];

  meta.broken = lib.isNixpkgsUnstable; # awscli2 broken atm
}
