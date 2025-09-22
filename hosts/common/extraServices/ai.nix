{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.extraServices.ai;
in
{
  options.extraServices.ai.enable = mkEnableOption "Enable AI";
  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      acceleration = "rocm";
      # Optional: preload models, see https://ollama.com/library
      loadModels = [
        "codellama:7b"
      ];
    };
    services.open-webui = {
      enable = true;
      port = 8000;
    };
  };
}
