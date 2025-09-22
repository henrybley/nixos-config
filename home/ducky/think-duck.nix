{ config, ... }:
{
  imports = [
    ../common
    ../features/cli
    ../features/develop
    ../features/desktop
    ./home.nix
  ];

  features = {
    cli = {
      kitty.enable = true;
      fzf.enable = true;
      neofetch.enable = true;
      zsh.enable = true;
    };
    desktop = {
      wayland.enable = true;

      hyprland.enable = true;
      waybar.enable = true;
    };
    misc = {
      hetzner-storage.enable = true;
    };
  };

  wayland.windowManager.hyprland = {
    settings = {
      monitor = [ ",preferred,auto,auto" ];
    };
  };
}
