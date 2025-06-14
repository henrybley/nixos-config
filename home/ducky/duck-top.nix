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
      hyprland.enaable = true;
      waybar.enable = true;
    };
  };
}
