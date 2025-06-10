{ config, ... }: {
  imports = [ ../common ../features/cli ./home.nix ];

  features = {
    cli = {
      zsh.enable = true;
      fzf.enable = true;
    };
  };
}
