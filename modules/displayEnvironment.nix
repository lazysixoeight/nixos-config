{ lib, config, pkgs, user, ... }:

with lib;

let
  cfg = config.displayEnvironment;
in {
  options.displayEnvironment = {
    session = mkOption {
      type = types.enum [ "i3" "sway" "hyprland" "gnome" "kde" "cosmic" "none" ];
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
    
    baseGnomehmConfig = mkOption {
      type = types.bool;
      default = false;
      description = "Enables the GNOME graphical configuration via home manager";
    };
  };

  config = mkMerge [
    {
      services.libinput.touchpad.naturalScrolling = true;
      security.polkit.enable = true;
      home-manager.backupFileExtension = "backup";
    }

    {
      displayEnvironment.x11Base = mkDefault (builtins.elem cfg.session [ "i3" "gnome" ]);
      displayEnvironment.basehmConfig = mkDefault (builtins.elem cfg.session [ "i3" "sway" "hyprland" ]);
      displayEnvironment.baseGnomehmConfig = mkDefault (builtins.elem cfg.session [ "gnome" ]);
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
        adwaita-qt
        adwaita-qt6
      ];
    })
    (mkIf cfg.baseGnomehmConfig {
      qt = {
        enable = true;
        platformTheme = "qt5ct";
        style = "kvantum";
      };
      home-manager.users.${user} = {
        home.pointerCursor = {
          name = "Simp1e-Adw";
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
            name = "Inter";
            size = 11;
          };
          # Set GTK theme
          theme = {
            name = "Adwaita-dark";
            package = pkgs.gnome-themes-extra;
          };
          # Set GTK icon theme
          iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme;
          };
        };
        home.stateVersion = "25.05";
      };
      environment.systemPackages = with pkgs; [
        adwaita-qt
        adwaita-qt6
      ];
    })
    # This is where display server declarations starts
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
      fonts.packages = with pkgs; [
        siji
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
        rofi
        wl-clipboard
      ];
      fonts.packages = with pkgs; [
        siji
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
        menulibre

        gnome-tweaks
        gnomeExtensions.dash-to-dock
        gnomeExtensions.blur-my-shell
        gnomeExtensions.just-perfection
        gnomeExtensions.appindicator
        gnomeExtensions.clipboard-indicator
        gnomeExtensions.caffeine
        gnomeExtensions.tiling-assistant
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
        gnome-software
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
      fonts.packages = with pkgs; [
        inter
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
        kdePackages.kalk
        simp1e-cursors
        (writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
          [General]
          background="${sddm-breeze-wallpaper-hack}"
        '')
      ];
      environment.plasma6.excludePackages = with pkgs; [
        kdePackages.okular
        kdePackages.kate
        kdePackages.konsole
      ];
    })
    (mkIf (cfg.session == "cosmic") {
      services.desktopManager.cosmic.enable = true;
      services.displayManager.cosmic-greeter.enable = true;
      environment.systemPackages = with pkgs; [
        wl-clipboard
        simp1e-cursors
        papirus-icon-theme
      ];
      environment.cosmic.excludePackages = with pkgs; [
        cosmic-term
        cosmic-edit
        cosmic-store
      ];
      fonts.packages = with pkgs; [
        inter
      ];
    })
  ];
}
