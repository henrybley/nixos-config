{ config, lib, pkgs, ... }:
with lib;
let cfg = config.extraServices.podman;
in {
  options.extraServices.podman.enable = mkEnableOption "enable podman";
  vonfig = mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        autoPrune = {
          enable = true;
          dates = "weekly";
          flags = [ "--filter=until=24h" "--filter=label!=important" ];
        };
        defaultNetwork.settings.dns_ensbled = true;
      };
    };
    environment.systemPackages = with pkgs; [ podman-compose ];
  };
}
