#----------------------------------------#
# Hey me!! Only install what you need!!! #
#----------------------------------------#

{ pkgs, user, lib, ... }:

{
  imports = [
    ../hardware-configuration.nix
    ../overlays

    ./modules/displayEnvironment.nix
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
    TERMINAL = "alacritty";
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
    dconf # State Management
    ffmpeg # Media Manipulation
    aria2 # Direct Downloads
    yt-dlp # Media Ripping
    fastfetch # System Fetch
    jq # Text Parser
    fd # Better Find
    fzf # Fuzzy Finder
    alsa-utils # ALSA Utilities
    ripgrep # Faster and modern grep
    ueberzugpp # Alacritty image support hack
    linuxKernel.packages.linux_zen.cpupower # Change CPU frequency at runtime
    
    # Wine Stuff
    wineWow64Packages.staging # Windows Compatibility Layer
    lutris # Running Windows Games
    bottles # General Prefix Management
    wineasio # Dynamic libraries providing ASIO to JACK translation layer
    winetricks # Wine Scripts

    # Build Tools/Dependency
    gcc # Because lazy.nvim needs it
    rustup # Needed by some LSPs
    gdb # Debug Tool
    nix-devShell # Creates flake.nix for devShell

    # Archiving
    atool # Unpacking and packing wrapper
    unrar
    unzip
    gnutar
    p7zip

    # Theming
    sddm-terminal # SDDM tty theme
    stow # Dotfiles Management
    gucharmap # Glyphs Search
    font-manager # Font Informations

    # Apps
    neovim # Text Editor
    discord # Communication
    obs-studio # Screen Capture
    firefox-bin # Browser
    libreoffice-still # Document Editor
    kitty # Terminal
    xterminate # Alacritty xterm PATH wrapper
    nicotine-plus # Audio P2P
    prismlauncher # Minecraft Launcher
    gimp # Image Manipulation Program
    yazi # File Manager
    mpv # Media Player
    btop # System Monitor
    keepassxc # Password Manager
    steam # Games
    qbittorrent # Torrenting

    # Music Production
    reaper # Digital Audio Workstation
    reaper-reapack-extension # Reaper Package Manager
    renoise # Tracker-based DAW
    yabridge # Bridge to use Wine plugins on Linux native DAWs
    yabridgectl # Yabridge CLI
    
    # Audio Plugins
    distrho-ports # Vitalium, A Wavetable synth
    oi-grandad # Granular Synth
    jc303 # TB303 Emulator
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
  displayEnvironment.session = "kde"; # Defined in displayEnvironment.nix
  
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
    kernelModules = [
      "snd-aloop"
    ];
    loader.timeout = 2;
  };
  boot.plymouth = {
    enable = true;
    theme = "monoarch";
    themePackages = [ pkgs.plymouth-monoarch-theme ];
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
            "default.clock.quantum" = 1024;
            "default.clock.min-quantum" = 64;
            "default.clock.max-quantum" = 1024;
          };
        };
      };
    };
  };
  security.rtkit.enable = true;
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
  services.dbus.enable = true;
  services.printing = {
    enable = true; 
    drivers = with pkgs; [
      hplipWithPlugin
      gutenprint
      epson-escpr
      brlaser
      foomatic-filters
      foomatic-db-engine
      foomatic-db
      foomatic-db-nonfree
    ];
  };
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

  documentation.man.generateCaches = false; # gtfo

  system.stateVersion = "25.05"; # Not really trivial, don't change 'less a new release comes out
}
