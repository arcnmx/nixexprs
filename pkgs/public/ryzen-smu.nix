{
  ryzen-smu-monitor_cpu = { stdenv, ryzen-smu, libsmu }: stdenv.mkDerivation {
    pname = "ryzen-smu-userspace";
    inherit (ryzen-smu) meta version src;

    buildInputs = [ libsmu ];

    buildPhase = ''
      rm -r lib
      $CC -lsmu userspace/monitor_cpu.c -o userspace/monitor_cpu
    '';

    installPhase = ''
      install -Dm0755 -t $out/bin/ userspace/monitor_cpu
    '';
  };

  libsmu = { stdenv, ryzen-smu }: stdenv.mkDerivation {
    pname = "libsmu";
    inherit (ryzen-smu) meta version src;

    makeFlags = [ "-C userspace" ];

    buildPhase = ''
      $CC -Ilib lib/libsmu.c -shared -o libsmu.so
    '';
    installPhase = ''
      install -Dm0755 -t $out/lib/ libsmu.so
      install -Dm0644 -t $out/include/ lib/libsmu.h
    '';
  };

  ryzen-smu-scripts = { python3Packages, ryzen-smu }: with python3Packages; let
    cpuid = buildPythonPackage {
      pname = "ryzen-smu-cpuid";
      inherit (ryzen-smu) src version meta;

      passAsFile = [ "setup" ];
      setup = ''
        from setuptools import setup
        setup(
          name='@pname@',
          version='@version@',
          py_modules=['cpuid'],
        )
      '';

      postPatch = ''
        substituteAll $setupPath scripts/setup.py
      '';

      preConfigure = ''
        cd scripts
      '';
    };
  in buildPythonApplication {
    pname = "ryzen-smu-scripts";
    inherit (ryzen-smu) meta version src;

    propagatedBuildInputs = [ cpuid ];

    postPatch = ''
      substituteAll $setupPath setup.py
      substituteInPlace scripts/monitor_cpu.py \
        --replace 'sys.path.append(os.path.abspath("."))' ""
    '';

    passAsFile = [ "setup" ];
    setup = ''
      from setuptools import setup
      setup(
        name='@pname@',
        version='@version@',
        install_requires = ['ryzen-smu-cpuid'],
        scripts = [
          'scripts/dump_pm_table.py',
          'scripts/monitor_cpu.py',
          'scripts/read_dump.py',
          'scripts/test.py',
        ],
      )
    '';

    postInstall = ''
      for f in $out/bin/*.py; do
        fname=$(basename $f)
        mv $f $out/bin/cmu_''${fname#.py}
      done
    '';

    passthru = {
      inherit cpuid;
    };
  };
  ryzen-monitor = { stdenv, fetchFromGitHub, ryzen-smu, libsmu }: stdenv.mkDerivation {
    pname = "ryzen-monitor";
    version = "2021-02-27";

    src = fetchFromGitHub {
      owner = "hattedsquirrel";
      repo = "ryzen_monitor";
      rev = "280c2304c36a886c24e0cef8227b4df45ea89296";
      sha256 = "0b6sqijwflqijn94ddkkycxdcnppgpwnl0rfkdwv4psac8cwhr8w";
    };

    buildInputs = [ libsmu ];
    makeFlags = "-C src";

    postPatch = ''
      rm -r src/lib
    '';
    buildPhase = ''
      $CC src/*.c -Isrc -lsmu -o src/ryzen_monitor
    '';
    installPhase = ''
      install -Dm0755 -t $out/bin/ src/ryzen_monitor
    '';
  };
}
