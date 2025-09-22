{ lib, config, pkgs, ... }: with lib;
{
  options.packageBundles = mkOption {
    type = types.listOf (types.enum [ "terminal" "apps" "audio" "wine" "sleuthing" "extra-fonts" ]);
    default = [ ];
    description = "Pull in packages in bulk.";
  };
  config = mkMerge [
    (mkIf (elem "terminal" config.packageBundles) {
      environment.systemPackages = with pkgs; [
        ripgrep # Pattern Matching
        jq # Text Parser
        stow # Symlinker, Dotfiles, whatever
        git # Its Git.
        fd # Better 'find'
        fzf # Fuzzy Finder
        killall # Terminates all running processes by name
        python313 # Don't mind me =)
        libvirt-glib

        atool # Unpacking and packing wrapper
        unrar # .rar
        unzip # .zip
        gnutar # tar.xz
        p7zip # .7z

        ffmpeg # Media Manipulation
        aria2 # File Downloading
        yt-dlp # Media Ripping

        alsa-utils # ALSA Utilities
        pulseaudio # Volume Control
        brightnessctl # Control Control
        
        fastfetch # System Fetch
        btop # System Monitor
        yazi # File Manager
        neovim # Text Editor
      ];
    })
    (mkIf (elem "apps" config.packageBundles) {
      environment.systemPackages = with pkgs; [
        # Apps
        discord # Communication
        obs-studio # Screen Capture
        firefox-bin # Browser
        libreoffice-still # Document Editor
        kitty # Terminal
        nicotine-plus # Audio P2P
        gimp # Image Manipulation Program
        mpv # Media Player
        keepassxc # Password Manager
        steam # Games
        qbittorrent # Torrenting
        gucharmap # Glyphs Search
        font-manager # Font Informations
      ];
    })
    (mkIf (elem "audio" config.packageBundles) {
      environment.systemPackages = with pkgs; [
        
        # DAWs
        reaper # Digital Audio Workstation
        reaper-reapack-extension # REAPER Package Manager
        renoise # Tracker-based DAW
        
        # Wine Stuff
        yabridge # Bridge to use Wine plugins on Linux native DAWs
        yabridgectl # Yabridge CLI
        
        # Audio Plugins
        distrho-ports # Vitalium, A Wavetable synth
        oi-grandad # Granular Synth
        octasine # FM Synth
        jc303 # TB303 Emulator
        tal-plugins # TAL-{Sampler,DAC,Drum}
      ];
    })
    (mkIf (elem "wine" config.packageBundles) {
      environment.systemPackages = with pkgs; [
        wineWow64Packages.staging # The Windows Compatibility Layer
        wineasio # Dynamic libraries providing ASIO to JACK translation layer
        winetricks # Wine Scripts
      ];
    })
    (mkIf (elem "sleuthing" config.packageBundles) {
      environment.systemPackages = with pkgs; [
        gau # Get All known URLs using third party
        httpx # HTTP Probing
        subfinder # Sub-domain Finder
        hakrawler # URL Crawler
      ];
    })
    (mkIf (elem "extra-fonts" config.packageBundles) {
      fonts.packages = with pkgs; [
        siji
        nerd-fonts.dejavu-sans-mono
        corefonts
      ];
    })
  ];
}
