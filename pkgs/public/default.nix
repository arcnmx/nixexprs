{
  i3gopher = import ./i3gopher;
  tamzen = import ./tamzen.nix;
  paswitch = import ./paswitch.nix;
  LanguageClient-neovim = import ./language-client-neovim.nix;
  base16-shell = import ./base16-shell.nix;
  efm-langserver = import ./efm-langserver;
  markdownlint-cli = import ./markdownlint-cli;
  clip = import ./clip.nix;
  nvflash = import ./nvflash.nix;
  nvidia-vbios-vfio-patcher = import ./nvidia-vbios-vfio-patcher;
  edfbrowser = import ./edfbrowser;
  mdloader = import ./mdloader.nix;
  muFFT = import ./mufft.nix;
  etterna = import ./etterna;
  libjaylink = import ./libjaylink.nix;
  openocd-git = import ./openocd-git.nix;
} // (import ./nixos.nix)
// (import ./droid.nix)
// (import ./weechat)
// (import ./crates)
// (import ./programs.nix)
// (import ./linux)
// (import ./ryzen-smu)
// (import ./matrix)
// (import ./pass)
// (import ../git)
