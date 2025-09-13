self: super:

let 
  pkgsStable = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/fe83bbdde2ccdc2cb9573aa846abe8363f79a97a.tar.gz";
    sha256 = "sha256:17dyfakqa9nafdwcwpndxj5807agw22iwzawicdvbnasfj615fiw";
  }) { inherit (super) system; };
in {
  tx16wx = (super.stdenv.mkDerivation {
    name = "tx16wx";
    src = super.fetchurl {
      url = "https://www.tx16wx.com/download/tx16wx-software-sampler-3-linux-x64-debian-2/?wpdmdl=19516&refresh=68c03ef42d94a1757429492";
      sha256 = "sha256-cOkzqdKfn/bSfxxRcAge8oIc/OqiLVxuEVGHAIWmcnw=";
    };
    nativeBuildInputs = with super; [
      autoPatchelfHook
      dpkg
    ];

    buildInputs = with super; [
      # XCB layer
      xorg.libxcb
      xorg.xcbutil           # libxcb-util.so.1 (if available in your nixpkgs)
      xcbutilxrm
      xorg.libXcursor
      xcb-util-cursor
      # XKB
      libxkbcommon

      # GTK / Pango / Cairo / fonts
      cairo
      pango
      fontconfig
      freetype
      libpng

      # GL / opengl (if the plugin uses GL)
      libepoxy
      libGL

      # GLib / GObject / GIO / secret
      glib
      libsecret

      # XML / other
      pkgsStable.libxml2
      liburing

      # C++ runtime
      super.stdenv.cc.cc

      # any other multimedia libs the plugin may need
      # e.g. alsa-lib, pulseaudio, libpulse, ffmpeg, etc.
      alsa-lib
    ];
    unpackPhase = ''
      dpkg-deb -x $src .
    '';
    installPhase = ''
      mkdir -p $out
      cp -r usr/* $out/
    '';
    postFixup = ''
      
    '';
  });
}

