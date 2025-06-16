{ config, lib, pkgs, ... }:
with lib; {
  home.packages = with pkgs; [ font-manager nerd-fonts.jetbrains-mono  ];
}
