{ self, ... }: let
  buildKakPlugin = self.callPackage ({ stdenvNoCC }: {
    src, sources ? null,
    name ? "${pname}-${attrs.version}",
    pname ? (builtins.parseDrvName name).name,
    ...
  } @ attrs: let
    drv = stdenvNoCC.mkDerivation ({
      kakrc = "share/kak/autoload/${pname}.kak";

      installPhase = ''
        runHook preInstall

        if [[ -d $src ]]; then
          target=$src
        else
          target=$out/share/kak/${pname}
          install -d $target
          cp -r . $target
        fi

        if [[ -n $sources ]]; then
          for source in $sources; do
            echo "source \"$target/$source\""
          done > rc.kak
        else
          find -L $target -type f -name '*.kak' -fprintf rc.kak 'source "%p"\n'
        fi

        install -Dm0644 rc.kak $out/$kakrc

        runHook postInstall
      '';
    } // attrs);
  in drv) { };
in {
  inherit buildKakPlugin;
}
