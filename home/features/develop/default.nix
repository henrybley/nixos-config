{ pkgs, ... }: {
  imports = [ ./nvim.nix ];

  home.packages = with pkgs; [
    eslint-lsp
    lua-language-server
    nil
    nixfmt
    php-cs-fixer
    phpactor
    prettierd
    python311Packages.python-lsp-server
    rust-analyzer
    stylua
    nodePackages.typescript-language-server
  ];

}
