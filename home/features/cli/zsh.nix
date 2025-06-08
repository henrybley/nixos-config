{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.cli.zsh;
in {
  options.features.cli.zsh.enable =
    mkEnableOption "enable extended zsh configuration";

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      antidote = {
        enable = true;
        package = pkgs.antidote;
        plugins = [
          "git"
          "zsh-users/zsh-autosuggestions"
          "zsh-users/zsh-syntax-highlighting"
        ];
      };

      shellInit = ''
            # xiong-chiamiov-plus prompt
            PROMPT=$'%{\e[0;34m%}%B┌─[%b%{\e[0m%}%{\e[1;32m%}%n%{\e[1;30m%}@%{\e[0m%}%{\e[0;36m%}%m%{\e[0;34m%}%B]%b%{\e[0m%} - %b%{\e[0;34m%}%B[%b%{\e[1;37m%}%~%{\e[0;34m%}%B]%b%{\e[0m%} - %{\e[0;34m%}%B[%b%{\e[0;33m%}'%D{"%a %b %d, %H:%M"}%b$'%{\e[0;34m%}%B]%b%{\e[0m%}
        %{\e[0;34m%}%B└─%B[%{\e[1;35m%}$%{\e[0;34m%}%B] <$(git_prompt_info)>%{\e[0m%}%b '

            PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '
      '';
    };
  };
}

