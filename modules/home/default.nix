{
  git = ./git.nix;
  github = ./github.nix;
  bitbucket = ./bitbucket.nix;
  sshd = ./sshd.nix;
  ssh = ./ssh.nix;
  konawall = ./konawall.nix;
  task = ./task.nix;
  kakoune = ./kakoune.nix;
  rustfmt = ./rustfmt.nix;
  base16 = import ./base16.nix false;
  filebin = ./filebin.nix;
  display = ./display.nix;
  buku = ./buku.nix;
  i3 = ./i3.nix;
  i3gopher = ./i3gopher.nix;
  lorri = ./lorri.nix;
  shell = ./shell.nix;
  less = ./less.nix;
  firefox = ./firefox.nix;
  tridactyl = ./tridactyl.nix;
  ncpamixer = ./ncpamixer.nix;
  ncmpcpp = ./ncmpcpp.nix;
  mpd = ./mpd.nix;
  pulsemixer = ./pulsemixer.nix;
  nix-path = ./nix-path.nix;
  offlineimap = ./offlineimap.nix;
  syncplay = ./syncplay.nix;
  imv = ./imv.nix;
  weechat = ./weechat.nix;
  systemd = ./systemd.nix;
  swaylock = ./swaylock.nix;
  xdg = ./xdg.nix;

  __functionArgs = { };
  __functor = self: { ... }: {
    imports = with self; [
      git github bitbucket
      sshd ssh
      konawall
      task
      kakoune
      rustfmt
      base16
      filebin
      display
      buku
      i3 i3gopher
      lorri
      shell
      less
      firefox
      tridactyl
      ncpamixer
      ncmpcpp
      mpd
      pulsemixer
      nix-path
      offlineimap
      syncplay
      imv
      weechat
      systemd
      swaylock
      xdg
    ];
  };
}
