#----------------------------------------#
# Hey me!! Only install what you need!!! #
#----------------------------------------#

{ pkgs, user, ... }:

{
  # Nix Stuff
  imports = [
    ../hardware-configuration.nix
    ../overlays

    ../modules/displayEnvironment.nix
    ../modules/packageBundles.nix
    ../modules/virtalisationStack.nix
    ../modules/bootSettings.nix
  ];

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  # User & Environment Variables
  users.users.${user} = {
    isNormalUser = true;
    description = "${user}";
    extraGroups = [ "networkmanager" "libvirtd" "wheel" "audio" "input" ];
    shell = pkgs.fish;
  };
  environment.variables = {
    EDITOR = "nvim";
    TERMINAL = "alacritty";
    VST_PATH = [ "/run/current-system/sw/lib/vst" "/home/${user}/.vst" ];
    VST3_PATH = [ "/run/current-system/sw/lib/vst3" "/home/${user}/.vst3" ];
  };

  # Packages
  packageBundles = [
    "terminal" # General CLI stuff
    "apps" # General GUI stuff
    "audio" # REAPER, Renoise, etc.
    "wine"
    #"sleuthing" # Hackerman stuff
    "extra-fonts"
  ];
  services.flatpak.enable = true;

  # Declare Programs
  programs = {
    fish.enable = true;
    nix-ld.enable = true; # Run unpatched dynamic binaries
  };

  virtualisationStack = {
    libvirtd.enable = true;
    waydroid.enable = false;
  };
  
  # Display service to use
  displayEnvironment.session = "gnome"; # Defined in displayEnvironment.nix
  
#
# Boot Settings
#

  bootSettings = {
    linuxKernel = "zen";
    loader = "grub";
    plymouth.enable = true;
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
# Miscellaneous
#
  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";

  documentation.man.generateCaches = false; # gtfo

  system.stateVersion = "25.05"; # Not really trivial, don't change 'less a new release comes out
}
