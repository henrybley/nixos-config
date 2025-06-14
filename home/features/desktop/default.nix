{ pkgs, ... }: {
  imports = [ ./wayland.nix ./hyprland.nix ./waybar.nix ];

  home.packages = with pkgs;
    [

    ];

}
