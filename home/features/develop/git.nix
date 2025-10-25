{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git
    delta
  ];

  home.sessionVariables = {
    DELTA_FEATURES = "+side-by-side";
  };

  programs.lazygit = {
    enable = true;
    settings.git.paging = {
      colorArg = "always";
      pager = "delta --dark --paging=never";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Henry Bley";
      user.email = "me@henrybley.com";
      push.autoSetupRemote = true;
      core.pager = "delta";
    };
  };

}
