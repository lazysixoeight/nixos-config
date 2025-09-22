{ lib, config, pkgs, ... }: with lib;
let
  cfg = config.virtualisationStack;
in {
  options.virtualisationStack.enable = mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether to enable the full virtualisation stack (libvirtd + QEMU + virt-manager + virbr0 firewall)";
  };

  config = mkMerge [
    (mkIf cfg.enable { 
      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
          ovmf = {
            enable = true;
            packages = [(pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd];
          };
        };
      };
      programs.virt-manager.enable = true;
      networking.firewall = {
        enable = true;
        trustedInterfaces = [ "virbr0" ];
      };
    })
  ];
  
}
