{
  config,
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
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
