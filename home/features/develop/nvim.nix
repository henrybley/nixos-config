{ inputs, lib, ... }:
{
  home.activation.populateNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.config/nvim" ] || [ -z "$(ls -A $HOME/.config/nvim)" ]; then
      echo "Populating Neovim config..."
      cp -r ${inputs.nvim-config} "$HOME/.config/nvim"
    else
      echo "Skipping Neovim config population (directory exists and is not empty)."
    fi
  '';

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
