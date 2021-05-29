{
  paused = { stdenvNoCC, mpv-unwrapped, lib, fetchFromGitHub }: stdenvNoCC.mkDerivation rec {
    pname = "paused";
    version = "2021-05-29";

    src = fetchFromGitHub {
      owner = "kittywitch";
      repo = "mpvScripts";
      rev = "0a41713c8413494de6b2032a5806706699c79b01";
      sha256 = "0mdkdwpg8yafiwmra3qi3ni580fjvprdq7dkhklns1axdbr1p7c2";
    };

    dontBuild = true;
    dontUnpack = true;

    installPhase = ''
      install -Dm644 ${src}/paused.lua $out/share/mpv/scripts/paused.lua
    '';

    passthru.scriptName = "paused.lua";

    meta = {
      description = "Automatically hides and shows OSC based upon pause status";
    };
  };
}
