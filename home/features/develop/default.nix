{ pkgs, ... }: {
  imports = [ ./nvim.nix ];

  home.packages = with pkgs; [
    lua-language-server
    nil
    nixfmt
    php83Packages.php-cs-fixer
    phpactor
    prettierd
    python313Packages.python-lsp-server
    rust-analyzer
    stylua
    typescript-language-server
  ];

}
