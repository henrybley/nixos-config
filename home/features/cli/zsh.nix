{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.cli.zsh;
in {
  options.features.cli.zsh.enable =
    mkEnableOption "enable extended zsh configuration";

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      programs.zsh.autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell"; # Choose a theme
        plugins = [ "git" "zsh-autosuggestions" "zsh-syntax-highlighting" ];
      };
    };
  };
}

