{ pkgs, ... }:
{
  imports = [
    ../common
    ../features/cli
    ../features/develop
    ../features/desktop
    ../features/streaming
    ../features/misc
    ./home.nix
  ];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
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
    };
    misc = {
      rclone.enable = true;
    };
    streaming = {
      enable = true;
    };
  };

  wayland.windowManager.hyprland = {
    settings = {
      monitor = [ ",preferred,auto,auto" ];
    };
  };
}
