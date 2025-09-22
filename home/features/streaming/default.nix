{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.features.streaming;
in
{
  options.features.streaming.enable = mkEnableOption "Streaming Setup";
  config = mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    };

  };
}
