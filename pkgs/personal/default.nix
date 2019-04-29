{ callPackage }:
{
  i3workspaceoutput = callPackage ./i3workspaceoutput { };
  getquote-alphavantage = callPackage ./getquote-alphavantage.nix { };
  konawall = callPackage ./konawall { };
  benc = callPackage ./benc { };
  qemucomm = callPackage ./qemucomm.nix { };
  filebin = callPackage ./filebin { };
  winpath = callPackage ./winpath.nix { };
  task-blocks = callPackage ./task-blocks.nix { };
} // (import ./yggdrasil-7n/default.nix { inherit callPackage; })
