{ lib, config, pkgs, ... }: with lib;
let

cfg = config.bootSettings;

in {
  options.bootSettings = {
    linuxKernel = mkOption {
      type = types.enum [ "zen" "vanilla" ];
      default = "vanilla";
      description = "Which predefined options for the Linux kernel to use";
    };
    loader = mkOption {
      type = types.enum [ "systemd-boot" "grub" ];
      default = "systemd-boot";
      description = "Which predefined options for the bootloader to use";
    };
    plymouth.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the Plymouth theme";
    };
  };
  config = mkMerge [
    {
      boot = {
        loader = {
          efi.canTouchEfiVariables = true;
          timeout = 2;
        };
      };
    }
    (mkIf (cfg.linuxKernel == "zen") {
      boot.kernelPackages = pkgs.linuxPackages_zen;
      environment.systemPackages = [ pkgs.linuxKernel.packages.linux_zen.cpupower ];
    })
    (mkIf (cfg.linuxKernel == "vanilla") {
      boot.kernelPackages = pkgs.linuxPackages;
      environment.systemPackages = [ pkgs.linuxKernel.packages.linux_6_16.cpupower ];
    })
    (mkIf (cfg.loader == "systemd-boot") {
      boot.loader.systemd-boot.enable = true;
    })
    (mkIf (cfg.loader == "grub") {
      boot.loader.grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    })
    (mkIf cfg.plymouth.enable {
      boot = {
        plymouth = {
          enable = true;
          theme = "monoarch";
          themePackages = [ pkgs.plymouth-monoarch-theme ];
        };
        initrd = {
          systemd.enable = true;
          verbose = false;
        };
        consoleLogLevel = 3;
        kernelParams = [
          "splash"
          "quiet"
          "boot.shell_on_fail"
          "udev.log_priority=3"
          "rd.systemd.show_status=auto"
        ];
      };
    })
  ];
}
