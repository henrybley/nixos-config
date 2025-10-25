{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.extraServices.virtualisation;
in
{
  options.extraServices.virtualisation.enable = mkEnableOption "Enable
    Virtualisation";
  config = mkIf cfg.enable {
    programs.dconf.enable = true;

    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      win-virtio
      win-spice
    ];

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
        };
      };
      spiceUSBRedirection.enable = true;
    };
    services.spice-vdagentd.enable = true;
  };
}
