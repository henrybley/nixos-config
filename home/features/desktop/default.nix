{ inputs, pkgs, ... }:
{
  imports = [
    ./wayland.nix
    ./hyprland.nix
    ./waybar.nix
    ./fonts.nix
  ];

  home.packages = with pkgs; [
    inputs.duckshell.packages.${pkgs.system}.duckshell
  ];
}
