{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.cli.zsh;
in {
  options.features.cli.zsh.enable =
    mkEnableOption "enable extended zsh configuration";

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      prezto.caseSensitive = false;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initContent = ''
        setopt autocd # auto cd when only path is entered
        setopt nomatch # throw an error on glob matching nothing
        setopt nonomatch
        setopt appendhistory
        setopt hist_ignore_all_dups # remove older duplicate entries from history
        setopt hist_reduce_blanks # remove superfluous blanks from history items
        setopt inc_append_history # save history entries as soon as they are entered
        setopt share_history # share history between different instances of the shell
        setopt auto_cd # cd by typing directory name if it's not a command
        unsetopt correct_all
        setopt auto_list # automatically list choices on ambiguous completion
        setopt auto_menu # automatically use menu completion
        setopt always_to_end # move cursor to end if word had one match
        setopt incappendhistory  #Immediately append to the history file, not just when a term is killed
        zstyle ':completion:*' menu select # select completions with arrow keys
        zstyle ':completion:*' group-name \'\' # group results by category
        zstyle ':completion:::::' completer _expand _complete _ignored _approximate #enable approximate matches for completion
        export PATH=$PATH:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.spicetify
        export NIX_PAGER=cat
        export PROMPT_EOL_MARK=" "
        [ -f "$HOME/.config/zsh/colors_and_functions.zsh" ] && source $HOME/.config/zsh/colors_and_functions.zsh
      '';
      oh-my-zsh = {
        enable = true;
        theme = "xiong-chiamiov-plus";
        plugins = [
          "sudo"
          "history-substring-search"
          "git"
          "web-search"
          "vi-mode"
        ];
      };
    };
  };
}

