{ pkgs, ... }:
{
  imports = [
    ./wayland.nix
    ./hyprland.nix
    ./quickshell.nix
    ./waybar.nix
    ./fonts.nix
  ];

  home.packages = with pkgs; [

  ];

}
