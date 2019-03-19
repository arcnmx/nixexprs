{
  package, substituteShellScriptBin,
  coreutils, awscli, curl ? null
}:
package (substituteShellScriptBin "filebin" ./filebin.sh) {
  depsRuntimePath = [coreutils awscli curl];
}
