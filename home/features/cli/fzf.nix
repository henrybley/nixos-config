{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.cli.zsh;
in {
  options.features.cli.fzf.enable = mkEnableOption "enable fuzzy finder";

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}

