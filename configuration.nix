#----------------------------------------#
# Hey me!! Only install what you need!!! #
#----------------------------------------#

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  
  programs.fish.enable = true;
  users.users.lazy = {
    isNormalUser = true;
    description = "lazy";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };
  environment.variables = {
    EDITOR = "nvim";
    TERMINAL = "foot";
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Utils
    git # Git.
    python312 # (Vanilla) Python for scripting
    fastfetch # System fetch
    brightnessctl # Brightness control
    inotify-tools # inotify Stuff
    libnotify # Notifications
    dconf # State Management

    # Archiving
    atool
    unrar
    unzip
    gnutar

    # Theming
    stow # Dotfiles Management
    gucharmap # Glyphs Search
    font-manager # Font Informations
    simp1e-cursors # Cursor theme
    tango-icon-theme # Icon theme
    
    # Wayland/X11 Utils
    wl-clipboard # Clipboard
    i3blocks # Swaybar/i3bar
    vulkan-tools # vulkaninfo & other stuff
    eww # Widgets
    feh # Image Utility (X11/Xwayland)
    dunst # Notifications
    wob # Progress Bar (Volume, Brightness, etc.)

    # Wine Stuff
    bottles # For managing prefixes

    # Apps
    neovim # Text Editor
    wofi # App Launcher
    firefox # Browser
    foot # Terminal
    yazi # File Manager
    btop # System Monitor
    fsearch # Search for everything
    flameshot # Screenshotting
    keepassxc # Password Manager
    steam  # Games
    ffmpeg # Media Manipulation
    wget # Direct Downloads
    qbittorrent # Torrenting
    yt-dlp # Media Ripping
    networkmanagerapplet # Networking
    
    # Audio-related
    renoise # DAW
    rubberband # Time-stretching and Pitch-shifting
    soulseekqt # Audio P2P
  ];
  fonts.packages = with pkgs; [
    siji
    unstable.nerd-fonts.dejavu-sans-mono
  ];

#
# Display Services
#
  programs.sway.enable = true; 
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
# Boot Settings
#
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

#
# Hardware Stuff
#
  services.printing.enable = true; # CUPS
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ # You may have to change this outside
      vaapiIntel intel-media-driver
    ];
  };

#  
# Trivial Stuff
#
  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "24.11"; # Not really trivial, don't change 'less you know what you're doing
}
