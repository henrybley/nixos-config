{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.extraServices.printing;
in
{
  options.extraServices.printing.enable = mkEnableOption "enable printing";
  config = mkIf cfg.enable {
    services.printing = {
      enable = true;
      # drivers = [
      #   pkgs.gutenprint
      # ];
      browsing = true;
    };

    hardware.sane.enable = true;
    hardware.sane.extraBackends = [ pkgs.sane-airscan ];

    users.users.ducky.extraGroups = [
      "scanner"
      "lp"
    ];

    environment.etc."sane.d/airscan.conf".text = ''
      [options]
      disable-certificate-check = yes

      [devices]
      "Canon TS7450i" = https://192.168.0.242:443/eSCL, disable-certificate-check=yes
    '';

    environment.systemPackages = with pkgs; [ simple-scan ];

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
