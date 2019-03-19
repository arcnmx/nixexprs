rec {
  arc = import ./arc.nix;
  profiles = import ./profiles.nix;
  ordered = [arc];
}
