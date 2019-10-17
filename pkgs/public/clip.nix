let
  rev = "ea337e9a0884a47c7a303d63b42652c11dfe6aa2";
  sha256 = "1904fzbvqqb7vmp48x1nw0j2kb0bvc8q9bc30p6pwm42llq0nhix";
  clip = builtins.fetchTarball {
    url = "https://github.com/arcnmx/clip/archive/${rev}.tar.gz";
    inherit sha256;
  };
in import (clip + "/derivation.nix")
