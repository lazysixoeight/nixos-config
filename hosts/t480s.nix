#----------------------------------------#
# Hey me!! Only install what you need!!! #
#----------------------------------------#

{ config, pkgs, lib, ... }:

let
  user = "lazy";
in

{
  imports = [
    ../hardware-configuration.nix
    ../overlays
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.users.${user} = {
    isNormalUser = true;
    description = "${user}";
    extraGroups = [ "networkmanager" "wheel" "audio" "input" ];
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
    killall # to kill
    pulseaudio # Volume Control
    inotify-tools # inotify Stuff
    libnotify # Notifications
    samba # Windows-Linux communication of some sort
    dconf # State Management
    ffmpeg # Media Manipulation
    xterminate # Makes certain apps launch the desired terminal
    wget # Direct Downloads
    yt-dlp # Media Ripping
    jq # Text Parser
    fd # Better Find
    fzf # Fuzzy Finder
    ripgrep # Faster and modern grep
    
    # Wine Stuff
    wineWow64Packages.staging # Windows Compatibility Layer
    lutris # Running Windows Games
    bottles # General Prefix Management
    #wineasio # Dynamic libraries providing ASIO to JACK translation layer
    winetricks # Wine Scripts

    # Build Tools
    gcc # Because lazy.nvim needs it
    rustup # Needed by some LSPs
    python312 # Python.
    gdb # Debug Tool
    nix-devShell # Creates flake.nix for devShell

    # Archiving
    atool # Unpacking and packing wrapper
    unrar
    unzip
    gnutar
    p7zip

    # Theming
    stow # Dotfiles Management
    gucharmap # Glyphs Search
    font-manager # Font Informations
    libsForQt5.qt5ct
    qt6ct
    adwaita-qt
    adwaita-qt6

    # Wayland/X11 Utils
    wl-clipboard # Clipboard
    waybar # Statusbar
    dunst # Notification
    swaylock-effects # Lockscreen
    swayidle # Idle Handler
    wob # Progress Bar (Volume, Brightness, etc.)
    rofi # App Launcher

    # Apps
    neovim # Text Editor
    discord # Communication
    obs-studio # Screen Capture
    firefox-bin # Browser
    libreoffice-still # Document Editor
    foot # Terminal
    gimp # Image Manipulation Program
    yazi # File Manager
    mpv # Media Player
    btop # System Monitor
    keepassxc # Password Manager
    steam # Games
    qbittorrent # Torrenting

    # Music Production
    plugdata # Visual Programming Language for Audio
    reaper # Digital Audio Workstation
    reaper-reapack-extension # Reaper Package Manager
    yabridge # Bridge to use Wine plugins on Linux native DAWs
    yabridgectl # Yabridge CLI
    decent-sampler # Sampler Plugin
    chow-tape-model # Tape Recording Emulation
    dexed # FM Synth
    vitalium # Wavetable Synth
    lsp-plugins # Linux Studio Plugins Suite
    nicotine-plus # Audio P2P
  ];
  fonts.packages = with pkgs; [
    siji
    nerd-fonts.dejavu-sans-mono
    corefonts
  ];
  services.flatpak.enable = true;
  
  programs.nix-ld.enable = true; # Run unpatched dynamic binaries, ex: Mason.nvim

#
# Shell
#
  programs.fish.enable = true;

#
# Display Services
#
  security.polkit.enable = true;
  programs = {
    sway = {
      enable = true;
      package = pkgs.swayfx;
      extraPackages = [];
    };
  };
  #services.desktopManager.gnome = {
    #enable = true;
  #};
  services.displayManager.ly = {
    enable = true;
  };
#
# Theming
#
  qt = {
    enable = true;
    platformTheme = "qt5ct";
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
        name = "Simp1e";
        package = pkgs.simp1e-cursors;
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
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
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
    kernelPackages = pkgs.linuxPackages_zen; # Linux kernel to use
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

    extraConfig = {
      pipewire = {
        "20-clock-quantum" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.quantum" = 2048;
            "default.clock.min-quantum" = 64;
            "default.clock.max-quantum" = 4096;
          };
        };
      };
    };
  };
  security.pam.loginLimits = [
    {
      domain = "@audio";
      type = "-";
      item = "rtprio";
      value = "95";
    }
    {
      domain = "@audio";
      type = "-";
      item = "memlock";
      value = "unlimited";
    }
  ];
#
# Networking
#
  networking = {
    networkmanager.enable = true;
    hostName = "t480s";
  };
  services.resolved = {
    enable = true;
    dnsovertls = "opportunistic";
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

  system.stateVersion = "25.05"; # Not really trivial, don't change 'less a new release comes out
}
