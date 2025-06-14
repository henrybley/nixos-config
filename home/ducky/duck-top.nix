{ config, ... }: {
  imports = [ ../common ../features/cli ../features/desktop ./home.nix ];

  features = {
    cli = {
      fzf.enable = true;
      neofetch.enable = true;
      zsh.enable = true;
    };
    desktop = {
      wayland.enable = true;
      hyprland.enable = true;
      waybar.enable = true;
    };
  };
}
