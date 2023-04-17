{
  git = ./git.nix;
  github = ./github.nix;
  bitbucket = ./bitbucket.nix;
  devops = ./devops.nix;
  sshd = ./sshd.nix;
  ssh = ./ssh.nix;
  gmail = ./gmail.nix;
  konawall = ./konawall.nix;
  task = ./task.nix;
  page = ./page.nix;
  starship = ./starship.nix;
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
  mpc = ./mpc.nix;
  mpd = ./mpd.nix;
  pulsemixer = ./pulsemixer.nix;
  nix-path = ./nix-path.nix;
  offlineimap = ./offlineimap.nix;
  syncplay = ./syncplay.nix;
  imv = ./imv.nix;
  weechat = ./weechat.nix;
  systemd = ./systemd.nix;
  xdg = ./xdg.nix;
  watchdog = ./watchdog.nix;
  user = ./user.nix;
  bindings = ./bindings.nix;

  __functionArgs = { };
  __functor = self: { ... }: {
    imports = with self; [
      git github bitbucket devops
      sshd ssh
      gmail
      konawall
      task
      page
      starship
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
      ncmpcpp mpc
      mpd
      pulsemixer
      nix-path
      offlineimap
      syncplay
      imv
      weechat
      systemd
      xdg
      watchdog
      user
      bindings
    ];
  };
}
