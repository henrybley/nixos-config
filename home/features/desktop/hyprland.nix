{ config, lib, ... }:
with lib;
let
  cfg = config.features.desktop.hyprland;
in
{
  options.features.desktop.hyprland.enable = mkEnableOption "hyprland config";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      settings = {

        monitor = [
          "HDMI-A-1, 1920x1080, 1080x440 , 1"
          "DP-2, 1920x1080, 0x0 , 1, transform, 1"
        ];

        # Program variables
        "$terminal" = "kitty";
        "$fileManager" = "dolphin";
        "$browser" = "brave-browser";
        "$browser_private" = "brave-browser --incognito";
        "$launcher" = "rofi -show drun -show-icons";
        "$runner" = "$HOME/.config/rofi/bin/runner";
        "$powermenu" = "$HOME/.config/rofi/bin/powermenu";
        "$screenshot" = "$HOME/.config/rofi/bin/screenshot";

        # Main modifier keys
        "$mainMod" = "SUPER";
        "$secondMod" = "ALT";

        # Autostart applications
        "exec-once" = [
          "waybar"
          "hyprpaper"
          "hypridle"
          "systemctl --user enable --now hyprland-autoname-workspaces.service"
        ];

        # Environment variables
        env = [
          "HYPR_NO_CURSOR_WARPING,1"
          "XCURSOR_THEME, Material-Cursors"
          "XCURSOR_SIZE,24"
          "QT_QPA_PLATFORM,wayland"
          "QT_QPA_PLATFORMTHEME,qt6ct"
          "GTK_THEME,Dracula"
        ];

        # General settings
        general = {
          gaps_in = 2;
          gaps_out = 4;
          border_size = 2;
          resize_on_border = true;
          allow_tearing = false;
          layout = "dwindle";
        };

        # Decoration settings
        decoration = {
          rounding = 3;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
        };

        # Animation settings
        animations = {
          enabled = true;
          bezier = "easeOut, 0, 0.55, 0.45, 1";
          animation = [
            "windows, 1, 0.5, easeOut"
            "windowsOut, 1, 1, easeOut, popin 80%"
            "border, 1, 1, easeOut"
            "borderangle, 1, 3, easeOut"
            "fade, 1, 3, default"
            "workspaces, 1, 3, easeOut"
          ];
        };

        # Dwindle layout settings
        dwindle = {
          pseudotile = true;
          preserve_split = true;
          force_split = 2;
        };

        # Miscellaneous settings
        misc = {
          force_default_wallpaper = -1;
          disable_hyprland_logo = false;
        };

        # Input settings
        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";
          follow_mouse = 1;
          sensitivity = 0;
          touchpad = {
            natural_scroll = false;
          };
        };

        # Gesture settings
        gestures = {
          workspace_swipe = false;
        };

        # Key bindings
        bind = [
          # Application launchers
          "$mainMod, Return, exec, $terminal"
          "$mainMod, B, exec, $browser"
          "$mainMod, F, exec, $fileManager"
          "$mainMod, Space, exec, $launcher"
          "$mainMod, D, exec, $powermenu"

          # Window management
          "$mainMod SHIFT, Q, killactive,"
          "$mainMod SHIFT, M, exit,"
          "$mainMod, V, togglefloating,"
          "$mainMod, S, togglesplit,"
          "$mainMod SHIFT, B, exec, ~/.config/waybar/launch.sh"
          "$mainMod SHIFT, T, togglefloating"

          # Volume controls
          "$mainMod, KP_ADD, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 2%+"
          "$mainMod, MINUS, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 2%-"
          "$mainMod SHIFT, KP_ADD, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 10%+"
          "$mainMod SHIFT, MINUS, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 10%-"

          # Screenshot
          ''$mainMod Shift, S, exec, grim -g "$(slurp)" ~/Pictures/screenshots/$(date '+screenshot_%F_%H:%M:%S.png')''

          # Focus movement (arrow keys)
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          # Focus movement (vim keys)
          "$mainMod, H, movefocus, l"
          "$mainMod, L, movefocus, r"
          "$mainMod, K, movefocus, u"
          "$mainMod, J, movefocus, d"

          # Workspace switching
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          # Move window to workspace
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          # Move workspace to other monitor
          "$mainMod, X, movecurrentworkspacetomonitor, +1"

          # Workspace scrolling
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"

          # Group management
          "$mainMod SHIFT, Tab, togglegroup"
          "$mainMod, Tab, changegroupactive"
        ];

        # Special binds with repeat
        bindel = [
          ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
          ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ];

        # Locked binds (work even when locked)
        bindl = [
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
        ];

        # Mouse bindings
        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        # Window rules
        windowrule = [
          "tile, class:(libresprite)"
          "float, class:(rust-extractor)"
          "size 900 600, class:(rust-extractor)"
          "suppressevent maximize, class:.*"
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        ];
      };
    };

    programs.zsh.profileExtra = ''
      if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
        exec Hyprland
      fi
    '';
  };
}
