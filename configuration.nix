#----------------------------------------#
# Hey me!! Only install what you need!!! #
#----------------------------------------#

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./overlays
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.fish.enable = true;
  users.users.lazy = {
    isNormalUser = true;
    description = "lazy";
    extraGroups = [ "networkmanager" "wheel" "audio" "jackaudio" ];
    shell = pkgs.fish;
  };
  environment.variables = {
    EDITOR = "nvim";
    TERMINAL = "foot";
    VST_PATH = "/run/current-system/sw/lib/vst";
    VST3_PATH = "/run/current-system/sw/lib/vst3";
  };

#
# Packages
#
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Utils
    git # Git.
    python312 # (Vanilla) Python for scripting
    brightnessctl # Brightness control
    inotify-tools # inotify Stuff
    libnotify # Notifications
    dconf # State Management
    figlet # Useless Text to ASCII Tool
    dotacat # Useless Rainbow Cat Tool
    bfetch # System Fetch
    pfetch

    # Build Tools
    gcc # Because lazy.nvim needs it
    rustup # Needed by some LSPs

    # Archiving
    atool # Unpacking and packing wrapper
    unrar
    unzip
    gnutar

    # Theming
    stow # Dotfiles Management
    gucharmap # Glyphs Search
    font-manager # Font Informations
    tango-icon-theme # Icon Theme

    # Wayland/X11 Utils
    wl-clipboard # Clipboard
    i3blocks # Swaybar/i3bar
    eww # Widgets
    feh # Image Utility (X11/Xwayland)
    dunst # Notifications
    wob # Progress Bar (Volume, Brightness, etc.)

    # Wine Stuff
    bottles # For managing prefixes

    # Apps
    unstable.neovim # Text Editor
    wofi # App Launcher
    firefox # Browser
    foot # Terminal
    yazi # File Manager
    btop # System Monitor
    fsearch # Search for everything
    flameshot # Screenshotting
    keepassxc # Password Manager
    steam # Games
    ffmpeg # Media Manipulation
    wget # Direct Downloads
    qbittorrent # Torrenting
    yt-dlp # Media Ripping
    networkmanagerapplet # Networking

    # Sounds Production
    renoise # Tracker-based DAW
    cardinal # Modular Synthesis
    rubberband # Time-stretching and Pitch-shifting
    cdp # Audio Manipulation
    soulseekqt # Audio P2P
  ];
  fonts.packages = with pkgs; [
    siji
    unstable.nerd-fonts.dejavu-sans-mono
  ];

  programs.nix-ld.enable = true; # Run unpatched dynamic binaries, ex: Mason.nvim

#
# Display Services
#
  programs.sway.enable = true;

#
# Theming
#
  qt = {
    enable = true;
    platformTheme = "gtk2";
  };
  
  home-manager.backupFileExtension = "backup";
  home-manager.users.lazy = {
    # Set cursor
    home.pointerCursor = {
      name = "Vanilla-DMZ";
      size = 24;
      package = pkgs.vanilla-dmz;
      gtk.enable = true;
    };
    gtk = {
      enable = true;
      cursorTheme = {
        name = "Vanilla-DMZ";
        package = pkgs.vanilla-dmz;
        size = 24;
      };
      # Set font
      font = {
        name = "DejaVu Sans";
        size = 11;
      };
      # Set GTK theme
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      # Set GTK icon theme
      iconTheme = {
        name = "Tango";
        package = pkgs.tango-icon-theme;
      };
    };
    home.stateVersion = "24.11";
  };
  # Boot Theming
  boot.plymouth = {
    enable = true;
    theme = "monoarch";
    themePackages = [ pkgs.plymouth-monoarch-theme ];
    extraConfig = ''
      Debug=true
    '';
  };

#
# Boot Settings
#
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelParams = [
      "splash"
      "quiet"
      "verbose"
      "plymouth.debug"
    ];
    loader.timeout = 0;
  };

#
# Audio
#
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
  };

#
# Networking
#
  networking = {
    networkmanager.enable = true;
    hostName = "nixos";
  };
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    dnsovertls = "true";
  };

#
# Drivers
#
  services.printing.enable = true; # CUPS
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # You may have to change this outside
      vaapiIntel
      intel-media-driver
    ];
  };

#
# Trivial Stuff
#
  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "24.11"; # Not really trivial, don't change 'less you know what you're doing
}
