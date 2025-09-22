{ pkgs, ... }:
{
  imports = [
    ./nvim.nix
    ./git.nix
    ./intellij.nix
  ];

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };

    zsh.enable = true;
  };

  home.packages = with pkgs; [
    gcc
    lua-language-server
    nil
    nixfmt-rfc-style
    php83Packages.php-cs-fixer
    phpactor
    prettierd
    python313Packages.python-lsp-server
    rust-analyzer
    stylua
    typescript-language-server
  ];

}
