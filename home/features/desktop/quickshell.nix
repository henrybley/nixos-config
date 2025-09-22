{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.desktop.quickshell;
in
{
  options.features.desktop.quickshell.enable = mkEnableOption "quickshell config";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      inputs.quickshell.packages.${pkgs.system}.default

      app2unit
      qt5.qtsvg
      qt5.qtimageformats
      qt5.qtmultimedia
      qt5.qtquickcontrols2

      qt6Packages.qt5compat
      libsForQt5.qt5.qtgraphicaleffects
      kdePackages.qtbase
      kdePackages.qtdeclarative
    ];
  };
}
