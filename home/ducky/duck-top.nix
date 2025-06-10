{ config, ... }: {
  imports = [ ../common ../features/cli ./home.nix ];

  features = {
    cli = {
      fzf.enable = true;
      neofetch.enable = true;
      zsh.enable = true;
    };
  };
}
