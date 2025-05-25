#----------------------------------------#
# Hey me!! Only install what you need!!! #
#----------------------------------------#

{ config, pkgs, lib, ... }:

let
  user = "lazy";
in

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
  users.users.${user} = {
    isNormalUser = true;
    description = "${user}";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    shell = pkgs.fish;
  };
  environment.variables = {
    EDITOR = "nvim";
    TERMINAL = "foot";
    VST_PATH = [ "/run/current-system/sw/lib/vst" "/home/${user}/.vst" ];
    VST3_PATH = [ "/run/current-system/sw/lib/vst3" "/home/${user}/.vst3" ];
  };

#
# Packages
#
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Utils
    git # Git.
    brightnessctl # Brightness Control
    pulseaudio # Volume Control
    inotify-tools # inotify Stuff
    libnotify # Notifications
    dconf # State Management
    ffmpeg # Media Manipulation
    figlet # Useless Text to ASCII Tool
    dotacat # Useless Rainbow Cat Tool
    bfetch # System Fetch Wrapper
    pfetch # System Fetch
    jq # Text Parser
    
    # Wine Stuff
    wineWowPackages.wayland
    wineasio
    winetricks

    # Build Tools
    gcc # Because lazy.nvim needs it
    rustup # Needed by some LSPs
    python312 # Python.
    gdb # Debug Tool
    tk # Pure Data dependency

    # Archiving
    atool # Unpacking and packing wrapper
    unrar
    unzip
    gnutar

    # Theming
    stow # Dotfiles Management
    gucharmap # Glyphs Search
    font-manager # Font Informations

    # Wayland/X11 Utils
    wl-clipboard # Clipboard
    waybar # Statusbar
    feh # Image Utility (X11/Xwayland)
    dunst # Notifications
    wob # Progress Bar (Volume, Brightness, etc.)

    # Apps
    unstable.neovim # Text Editor
    wofi # App Launcher
    firefox # Browser
    foot # Terminal
    libreoffice # Document Editor
    xterminate # Makes certain apps launch the desired terminal
    yazi # File Manager
    vlc # Video Player
    btop # System Monitor
    lutris # Run Games
    fsearch # Search for everything
    keepassxc # Password Manager
    steam # Games
    wget # Direct Downloads
    qbittorrent # Torrenting
    yt-dlp # Media Ripping

    # Sounds Production
    renoise # Tracker-based DAW
    cardinal # Modular Synthesis
    plugdata
    soulseekqt # Audio P2P
  ];
  fonts.packages = with pkgs; [
    siji
    nerd-fonts.dejavu-sans-mono
  ];
  services.flatpak = {
    enable = true;
    remotes = [
      { name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo"; }
    ];
    uninstallUnmanaged = false;
  };

  programs.nix-ld.enable = true; # Run unpatched dynamic binaries, ex: Mason.nvim

#
# Display Services
#
  security.polkit.enable = true;
  programs = {
    sway = {
      enable = true;
      extraPackages = [];
    };
  };
  #services.desktopManager.cosmic = {
    #enable = true;
    #xwayland.enable = true;
  #};
  services.displayManager.ly = {
    enable = true;
  };
#
# Theming
#
  qt = {
    enable = true;
    platformTheme = "gtk2";
  };
  
  home-manager.backupFileExtension = "backup";
  home-manager.users.${user} = {
    # Set cursor
    home.pointerCursor = {
      name = "Vanilla-DMZ";
      size = 24;
      package = pkgs.vanilla-dmz;
      gtk.enable = true;
    };
    # Tell GNOME to use dark mode
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
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
        name = "Gruvbox-Dark";
        package = pkgs.gruvbox-gtk-theme;
      };
      # Set GTK icon theme
      iconTheme = {
        name = "Moka";
        package = pkgs.faba-icon-theme;
      };
    };
    home.stateVersion = "25.05";
  };
  # Boot Theming
  boot.plymouth = {
    enable = true;
    theme = "monoarch";
    themePackages = [ pkgs.plymouth-monoarch-theme ];
  };

#
# Boot Settings
#
  boot = {
    loader.grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      splashImage = null;
    };
    loader.efi = {
      canTouchEfiVariables = true;
    };
    initrd.systemd.enable = true;

    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "splash"
      "quiet"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    loader.timeout = 2;
  };

#
# Portal (Allows desktop apps to access resources outside of their sandboxed environment)
#
  xdg.portal = {
    enable = true;
    config = { common = { default = [ "gtk" ]; }; };
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
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
    dnsovertls = "true";
  };

#
# Drivers
#
  services.printing.enable = true; # CUPS
  services.dbus.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      vaapiIntel
      intel-media-driver
    ];
  };

#
# Trivial Stuff
#
  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.05"; # Not really trivial, don't change 'less you know what you're doing
}
