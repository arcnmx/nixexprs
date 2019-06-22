{
  imports = [
    ./git.nix
    ./github.nix
    ./sshd.nix
    ./konawall.nix
    ./task.nix
    ./kakoune.nix
    ./symlink.nix
    ./filebin.nix
    ./i3.nix
    ./i3gopher.nix
    ./lorri.nix
    ./shell.nix
    (import ../nixos/keychain.nix false)
  ];
}
