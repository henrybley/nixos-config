{ pkgs, ... }:
{
  imports = [
    ./kitty.nix
    ./zsh.nix
    ./fzf.nix
    ./neofetch.nix
  ];

  programs.eza = {
    enable = true;
    extraOptions = [
      "-1"
      "--icons"
      "--git"
      "-a"
    ];
  };

  programs.bat = {
    enable = true;
  };

  home.packages = with pkgs; [
    coreutils
    fd
    btop
    httpie
    jq
    procs
    ripgrep
    tldr
    zip
    unzip
  ];

}
