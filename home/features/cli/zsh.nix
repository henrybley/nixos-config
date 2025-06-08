{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.cli.zsh;
in {
  options.features.cli.zsh.enable =
    mkEnableOption "enable extended zsh configuration";

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      oh-my-zsh = {
        enable = true;
        theme = "xiong-chiamiov-plus";
        plugins = [ "git" "zsh-users/zsh-autosuggestions" "zsh-users/zsh-syntax-highlighting" ];
      };
    };
  };
}

