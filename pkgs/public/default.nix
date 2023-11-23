{
  i3gopher = import ./i3gopher;
  glauth = import ./glauth.nix;
  konawall = import ./konawall.nix;
  paswitch = import ./paswitch.nix;
  clip = import ./clip.nix;
  nvflash = import ./nvflash.nix;
  nvidia-vbios-vfio-patcher = import ./nvidia-vbios-vfio-patcher;
  nvidia-capture-sdk = import ./nvidia-capture-sdk.nix;
  edfbrowser = import ./edfbrowser;
  mdloader = import ./mdloader.nix;
  muFFT = import ./mufft.nix;
  libjaylink = import ./libjaylink.nix;
  openocd-git = import ./openocd-git.nix;
  gst-jpegtrunc = import ./gst-jpegtrunc.nix;
  gst-protectbuffer = import ./gst-protectbuffer.nix;
  gst-rtsp-launch = import ./gst-rtsp-launch;
  zsh-completions-abduco = import ./zsh-completions-abduco.nix;
  lua-amalg = import ./lua-amalg.nix;
  github-label-sync = import ./github-label-sync;
  yggdrasil-address = import ./yggdrasil-address.nix;
  switch-lan-play = import ./switch-lan-play.nix;
  mdns-scan = import ./mdns-scan.nix;
  firenvim-native = import ./firenvim-native.nix;
  ddclient_3 = import ./ddclient.nix;
}
// (import ./bolin)
// (import ./droid.nix)
// (import ./weechat)
// (import ./looking-glass)
// (import ./crates)
// (import ./linux)
// (import ./ryzen-smu)
// (import ./matrix)
// (import ./pass)
// (import ../git)
