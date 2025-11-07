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
        nix-search-cli # Search packages on search.nixos.org

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
        lutris # Windows Games Prefix Manager
        nicotine-plus # Audio P2P
        strawberry # Music Player
        gimp # Image Manipulation Program
        vlc # Media Player
        cockatrice # Virtual Tabletop
        keepassxc # Password Manager
        kdePackages.filelight # Disk Space Analyze
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
        milkytracker # Music Tracker
        carla # Technically a DAW
        
        # Wine Stuff
        yabridge # Bridge to use Wine plugins on Linux native DAWs
        yabridgectl # Yabridge CLI
        
        # Audio Plugins
        distrho-ports # Vitalium, a Wavetable synth
        oi-grandad # Granular Synth
        dexed # FM Synth
        jc303 # TB303 Emulator
        tal-plugins # TAL-{DAC,Drum}
        glitch2 # FX Sequencer
        generic-drum # Drum Synthesizer \ Awesome plugin by Ryukau
        fluida-lv2 # SoundFont Player
      ];
    })
    (mkIf (elem "wine" config.packageBundles) {
      environment.systemPackages = with pkgs; [
        bottles # Prefix Management
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
        nerd-fonts.dejavu-sans-mono
        corefonts
      ];
    })
  ];
}
