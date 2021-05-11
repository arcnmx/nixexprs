{ lib, stdenv, fetchFromGitHub
, cmake, pkg-config, makeWrapper
, libX11, libXrandr, libGLU, libXext, glew
, libpulseaudio, alsaLib, jack2
, pcre, zlib, stb
, openssl, curl
, websocketpp, asio_1_10
, libmad, libogg, libvorbis
, libtomcrypt, libtommath, muFFT
, sqlite, sqlitecpp ? null
, rapidjson, discord-rpc
, luajit
}: with lib; stdenv.mkDerivation rec {
  pname = "etterna";
  version = "0.70.4";

  src = fetchFromGitHub {
    owner = "etternagame";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "1z36k0zq3dhmff5bnskziw2zqz9xh4ra5yiqgzd3h2v1xih9hhgl";
  };

  patches = [ ./cmake.patch ./nonportable.patch ];

  postPatch = ''
    sed -e '/portable\.ini/d' \
      -e 's-INSTALL_DIR "Etterna"-INSTALL_DIR "share/etterna"-' \
      -i CMake/Helpers/CPackSetup.cmake
    cat $installPath >> CMake/Helpers/CPackSetup.cmake
  '';

  postBuild = ''
    substituteAll $desktopPath etterna.desktop
  '';

  postInstall = ''
    install -d $out/bin
    makeWrapper $out/share/etterna/Etterna $out/bin/etterna \
      --set-default vblank_mode 0
  '';

  passAsFile = [ "install" "desktop" ];
  install = ''
    set_target_properties(Etterna PROPERTIES OUTPUT_NAME Etterna)
    install(TARGETS Etterna COMPONENT Etterna DESTINATION ''${INSTALL_DIR})
    install(FILES ''${PROJECT_SOURCE_DIR}/CMake/CPack/Windows/Install.ico DESTINATION share/etterna/)
    install(FILES ''${PROJECT_BINARY_DIR}/etterna.desktop DESTINATION share/applications/)
  '';
  desktop = ''
    [Desktop Entry]
    Version=@version@
    Name=Etterna
    Comment=A advanced cross-platform rhythm game focused on keyboard play.
    Exec=@out@/bin/etterna
    Icon=@out@/share/etterna/Install.ico
    Terminal=false
    Type=Application
    Categories=Game
    X-Desktop-File-Install-Version=0.24
  '';

  # bad devs...
  NIX_CFLAGS_COMPILE = ["-Wno-error=format-security"];

  # make the relevant warnings stand out better
  cmakeFlags = [ "-Wno-dev" ];

  nativeBuildInputs = [ cmake pkg-config makeWrapper ];

  buildInputs = [
    libX11 libXrandr libGLU libXext glew
    libpulseaudio alsaLib jack2
    pcre zlib stb
    openssl curl
    websocketpp asio_1_10
    libmad libogg libvorbis
    libtomcrypt libtommath muFFT
    sqlite sqlitecpp
    rapidjson discord-rpc
    luajit
  ];

  meta.broken = sqlitecpp == null; # introduced in 21.05
}
