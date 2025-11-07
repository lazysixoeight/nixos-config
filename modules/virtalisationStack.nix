{ lib, config, pkgs, ... }: with lib;
let
  cfg = config.virtualisationStack;
in {
  options.virtualisationStack = {
    libvirtd.enable = mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable the libvirtd stack (QEMU, virt-manager and additional network configurations)";
    };
    waydroid.enable = mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable Waydroid";
    };
  };

  config = mkMerge [
    (mkIf cfg.libvirtd.enable { 
      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
        };
      };
      programs.virt-manager.enable = true;
      networking.firewall = {
        enable = true;
        trustedInterfaces = [ "virbr0" ];
      };
    })
    (mkIf cfg.waydroid.enable { 
      virtualisation.waydroid.enable = true;
    })
  ];
  
}
