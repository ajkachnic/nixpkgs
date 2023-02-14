{ stdenv }:

stdenv.mkDerivation rec {
  pname = "musescore";
  version = "4.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "musescore";
    repo = "MuseScore";
    rev = "v${version}";
    hash = "";
  };

  qtWrapperArgs = [
    # MuseScore JACK backend loads libjack at runtime.
    "--prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [ pkgs.libjack2 pkgs.alsa-plugins ]
    }"
    # There are some issues with using the wayland backend, see:
    # https://musescore.org/en/node/321936
    "--set-default QT_QPA_PLATFORM xcb"
  ];

  # patches = [ ./remove_qtwebengine_install_hack.patch ];
  patches = [
    # See https://github.com/musescore/MuseScore/issues/15571
    (pkgs.fetchpatch {
      url =
        "https://github.com/musescore/MuseScore/commit/365be5dfb7296ebee4677cb74b67c1721bc2cf7b.patch";
      hash = "sha256-tJ2M21i3geO9OsjUQKNatSXTkJ5U9qMT4RLNdJnyoKw=";
    })
  ];

  cmakeFlags = [
    "-DMUSESCORE_BUILD_CONFIG=release"
    # Disable the _usage_ of the `/bin/crashpad_handler` utility. See:
    # https://github.com/musescore/MuseScore/pull/15577
    "-DBUILD_CRASHPAD_CLIENT=OFF"
    # "-DBUILD_JACK=ON"
    # Use our freetype
    "-DUSE_SYSTEM_FREETYPE=ON"
  ];

  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
    ninja
    libsForQt5.qt5.wrapQtAppsHook
  ];

  buildInputs = with pkgs; [
    pkg-config
    alsa-lib
    alsa-plugins
    libjack2
    freetype
    lame
    libogg
    libpulseaudio
    libsndfile
    libvorbis
    portaudio
    portmidi
    flac # tesseract
    libsForQt5.qt5.qtbase
    libsForQt5.qt5.qtdeclarative
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtscript
    libsForQt5.qt5.qtsvg
    libsForQt5.qt5.qttools
    libsForQt5.qt5.qtwebengine
    libsForQt5.qt5.qtxmlpatterns
    libsForQt5.qt5.qtnetworkauth
    libsForQt5.qt5.qtx11extras
  ];

}
