{ lib, config, pkgs, user, ... }:

with lib;

let
  cfg = config.displayEnvironment;
in {
  options.displayEnvironment = {
    session = mkOption {
      type = types.enum [ "i3" "sway" "hyprland" "gnome" "kde" "enlightenment" "none" ];
      default = "none";
      description = "Which session to use";
    };

    x11Base = mkOption {
      type = types.bool;
      default = false;
      description = "Enables the base X11 environment";
    };

    basehmConfig = mkOption {
      type = types.bool;
      default = false;
      description = "Enables the base graphical configuration via home manager";
    };
  };

  config = mkMerge [
    {
      services.libinput.touchpad.naturalScrolling = true;
      security.polkit.enable = true;
      home-manager.backupFileExtension = "backup";
    }

    {
      displayEnvironment.x11Base = mkDefault (builtins.elem cfg.session [ "i3" ]);
      displayEnvironment.basehmConfig = mkDefault (builtins.elem cfg.session [ "i3" "sway" "hyprland" "gnome" ]);
    }
    
    (mkIf cfg.x11Base {
      services.xserver = {
        enable = true;
        videoDrivers = [ "modesetting" ];
        displayManager.startx.enable = true;
        desktopManager.xterm.enable = true;
      };
    })
    
    (mkIf cfg.basehmConfig {
      qt = {
        enable = true;
        platformTheme = "qt5ct";
      };
      home-manager.users.${user} = {
        home.pointerCursor = {
          name = "Simp1e";
          size = 24;
          package = pkgs.simp1e-cursors;
          gtk.enable = true;
        };
        dconf = {
          enable = true;
          settings = {
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
            };
          };
        };
        gtk = {
          enable = true;
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
      environment.systemPackages = with pkgs; [
        libsForQt5.qt5ct
        kdePackages.qt6ct
        adwaita-qt
        adwaita-qt6
      ];
    })

    (mkIf (cfg.session == "i3") {
      services.xserver.windowManager.i3 = {
        enable = true;
        extraPackages = [];
      };
      environment.systemPackages = with pkgs; [
        xob
        eww
        picom-pijulius
        feh
        dunst
        rofi
        xclip
      ];
      xdg.portal = {
        enable = true;
        config = { common = { default = [ "gtk" ]; }; };
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };
    })

    (mkIf (cfg.session == "sway") {
      programs.sway = {
        enable = true;
        extraPackages = [];
        package = pkgs.swayfx;
      };
      environment.systemPackages = with pkgs; [
        wob
        waybar
        swaylock-effects
        swayidle
        dunst
        rofi-wayland
        wl-clipboard
      ];
      services.displayManager.ly.enable = true;
      xdg.portal = {
        enable = true;
        config = { common = { default = [ "gtk" ]; }; };
        extraPortals = [
          pkgs.xdg-desktop-portal-wlr
          pkgs.xdg-desktop-portal-termfilechooser
        ];
      };
    })

    (mkIf (cfg.session == "hyprland") {
      home-manager.users.${user} = {
        wayland.windowManager.hyprland = {
          enable = true;
          plugins = [ pkgs.hyprlandPlugins.hy3 ];
          extraConfig = ''
            source = ~/.config/hypr/config.conf
          '';
        };
      };
      environment.systemPackages = with pkgs; [
        wl-clipboard
        rofi-wayland
        swaybg
        quickshell
      ];
      services.displayManager.ly.enable = true;
      xdg.portal = {
        enable = true;
        config = { common = { default = [ "gtk" ]; }; };
        extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
      };
    })

    (mkIf (cfg.session == "gnome") {
      services.desktopManager.gnome.enable = true;
      services.displayManager.gdm.enable = true;
      environment.systemPackages = with pkgs; [
        wl-clipboard
        kgtfo

        gnomeExtensions.dash-to-dock
        gnomeExtensions.blur-my-shell
        gnomeExtensions.task-up-ultralite
        gnomeExtensions.appindicator
      ];
      environment.gnome.excludePackages = with pkgs; [
        gnome-terminal
        gnome-console
        gnome-text-editor
        gnome-music
        gnome-system-monitor
        gnome-contacts
        gnome-maps
        gnome-weather
        gnome-calendar
        gnome-clocks
        gnome-disk-utility
        gnome-logs
        gnome-font-viewer
        gnome-connections
        gnome-tour
        geary
        totem
        epiphany
        evince
        decibels
        yelp
        baobab
        simple-scan
        file-roller
        seahorse
      ];
    })
    (mkIf (cfg.session == "kde") {
      services.desktopManager.plasma6.enable = true;
      services.xserver.enable = true;
      services.displayManager.defaultSession = "plasmax11";
      services.displayManager.sddm = {
        enable = true;
      };
      environment.systemPackages = with pkgs; [
        wl-clipboard
        kdePackages.oxygen
        kdePackages.oxygen-icons
        kdePackages.oxygen-sounds
        kdePackages.plasma-browser-integration
        simp1e-cursors
      ];
      environment.plasma6.excludePackages = with pkgs; [
        kdePackages.okular
        kdePackages.kate
      ];
    })
    (mkIf (cfg.session == "enlightenment") {
      services.xserver = {
        enable = true;
        desktopManager.enlightenment.enable = true;
      };
      services.displayManager.sddm = {
        enable = true;
      };
      environment.systemPackages = with pkgs; [
        wl-clipboard
      ];
      environment.enlightenment.excludePackages = with pkgs; [
        enlightenment.econnman
      ];
      xdg.portal = {
        enable = true;
        config = { common = { default = [ "gtk" ]; }; };
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };
    })
  ];
}

