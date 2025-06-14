{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.cli.kitty;
in {
  options.features.cli.kitty.enable = mkEnableOption ''
    enable kitty with stylix
      colors'';

  config = mkIf cfg.enable {
    programs.kitty = lib.mkForce {
      enable = true;

      #font = {
      #  name = "JetBrains Mono";
      #size = 9.0;
      #};

      #settings = { disable_ligatures = "always"; };

      extraConfig = ''
        cursor_trail 3
        cursor_trail_decay 0.1 0.4
      '';
    };
  };
}
