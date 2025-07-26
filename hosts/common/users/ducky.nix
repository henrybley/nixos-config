{
  config,
  pkgs,
  inputs,
  ...
}:
{
  users.users.ducky = {
    initialHashedPassword = "$y$j9T$Nx1fkTmVOuvRoavY3gtiZ.$Z7mBxr7Kh9mKeWaVxOaUPdG9MmwMCUQRDB6hFufrEY4";
    isNormalUser = true;
    description = "ducky";
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "flatpak"
      "audio"
      "video"
      "plugdev"
      "input"
      "kvm"
      "qemu-libvirtd"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGqtJZJLCo3aOx5ykz0mS5fsRNUq2LkEmq4CYdj/sUwu nix-laptop"
    ];
    packages = [ inputs.home-manager.packages.${pkgs.system}.default ];
  };
  home-manager.users.ducky = import ../../../home/ducky/${config.networking.hostName}.nix;
}
