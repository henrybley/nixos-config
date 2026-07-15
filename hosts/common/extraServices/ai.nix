{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.extraServices.ai;
  pkgs-bleeding = import inputs.nixpkgs-bleeding {
    system = pkgs.system;  # use pkgs.system instead of bare system
    config.allowUnfree = true;
  };
in
{
  options.extraServices.ai.enable = mkEnableOption "Enable AI";
  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      package = pkgs-bleeding.ollama-vulkan;
      environmentVariables = {
        OLLAMA_VULKAN = "1";
      };
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
