{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.extraServices.ovpn;
in
{
  options.extraServices.ovpn.enable = mkEnableOption "enable Open VPN";
  config = mkIf cfg.enable {
    services.openvpn.servers = {
      liftoff_vpn = {
        config = ''config /home/ducky/vpn/henry-vpn2.ovpn '';
        autoStart = false;
      };
    };
  };
}
