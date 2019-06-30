{
  package, wrapShellScriptBin,
  coreutils, inetutils, curl, jq, xrandr ? null, feh ? null, xsetroot ? null, sway ? null,
  hostPlatform,
  swaySupport ? hostPlatform.isLinux,
  xorgSupport ? hostPlatform.isLinux
}:

assert swaySupport -> sway != null;
assert xorgSupport -> (feh != null && xsetroot != null && xrandr != null);

package (wrapShellScriptBin "konawall" ./konawall.sh) {
  depsRuntimePath = [coreutils inetutils curl jq] ++
    (if xorgSupport then [feh xsetroot xrandr] else []) ++
    (if swaySupport then [sway] else []);
}
