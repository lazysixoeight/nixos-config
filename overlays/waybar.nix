self: super:
let
  cavaSupport = false;
  enableManpages = true;
  evdevSupport = true;
  experimentalPatches = true;
  inputSupport = true;
  jackSupport = true;
  mpdSupport = true;
  mprisSupport = true;
  niriSupport = true;
  nlSupport = true;
  pipewireSupport = true;
  pulseSupport = true;
  rfkillSupport = true;
  runTests = false;
  sndioSupport = true;
  systemdSupport = true;
  traySupport = true;
  udevSupport = true;
  upowerSupport = true;
  wireplumberSupport = true;
  withMediaPlayer = false;
in
{
  waybar = super.waybar.overrideAttrs (oldAttrs: {
    pname = "waybar";
    version = "0.12.0";

    src = super.fetchFromGitHub {
      owner = "DreamMaoMao";
      repo = "Waybar";
      rev = "dwl-tags-hide-vacant";
      sha256 = "sha256-/K8kguwSPVYCqJa2E41eOatDBQmY0YSBILRxUGVa3oU=";
    };
    
  # cant build cava dont even bother
  postUnpack = super.lib.optional cavaSupport ''
    pushd "$sourceRoot"
    cp -R --no-preserve=mode,ownership ${super.libcava.src} subprojects/cava-0.10.2
    patchShebangs .
    popd
  '';

    buildInputs = [
      super.gtk-layer-shell
      super.gtkmm3
      super.howard-hinnant-date
      super.jsoncpp
      super.libsigcxx
      super.libxkbcommon
      super.spdlog
      super.wayland
    ] ++ super.lib.optionals cavaSupport [
      super.SDL2
      super.alsa-lib
      super.fftw
      super.iniparser
      super.ncurses
      super.portaudio
    ] ++ super.lib.optional evdevSupport super.libevdev
      ++ super.lib.optional inputSupport super.libinput
      ++ super.lib.optional jackSupport super.libjack2
      ++ super.lib.optional mpdSupport super.libmpdclient
      ++ super.lib.optional mprisSupport super.playerctl
      ++ super.lib.optional nlSupport super.libnl
      ++ super.lib.optional pulseSupport super.libpulseaudio
      ++ super.lib.optional sndioSupport super.sndio
      ++ super.lib.optional systemdSupport super.systemdMinimal
      ++ super.lib.optional traySupport super.libdbusmenu-gtk3
      ++ super.lib.optional udevSupport super.udev
      ++ super.lib.optional upowerSupport super.upower
      ++ super.lib.optional wireplumberSupport super.wireplumber
      ++ super.lib.optional (cavaSupport || pipewireSupport) super.pipewire
      ++ super.lib.optional (!super.stdenv.hostPlatform.isLinux) super.libinotify-kqueue;

    mesonFlags =
      (super.lib.mapAttrsToList super.lib.mesonEnable {
        "cava" = cavaSupport && super.lib.asserts.assertMsg sndioSupport "Sndio support is needed for Cava";
        "dbusmenu-gtk" = traySupport;
        "jack" = jackSupport;
        "libevdev" = evdevSupport;
        "libinput" = inputSupport;
        "libnl" = nlSupport;
        "libudev" = udevSupport;
        "man-pages" = enableManpages;
        "mpd" = mpdSupport;
        "mpris" = mprisSupport;
        "pipewire" = pipewireSupport;
        "pulseaudio" = pulseSupport;
        "rfkill" = rfkillSupport;
        "sndio" = sndioSupport;
        "systemd" = systemdSupport;
        "tests" = runTests;
        "upower_glib" = upowerSupport;
        "wireplumber" = wireplumberSupport;
      })
      ++ (super.lib.mapAttrsToList super.lib.mesonBool {
        "experimental" = experimentalPatches;
        "niri" = niriSupport;
      });

    # optionally override more here if needed
  });
}

