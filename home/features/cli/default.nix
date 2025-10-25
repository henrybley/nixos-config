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

  programs.zsh.shellAliases = {
    cat = "bat";
  };

  home.packages = with pkgs; [
    tree
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
