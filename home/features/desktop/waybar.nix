{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.waybar;
in {
  options.features.desktop.waybar.enable = mkEnableOption "waybar config";

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      style = ''
        @define-color primary rgba(255, 120, 0, 1);
        @define-color secondary rgba(255, 255, 255, .7);
        @define-color background rgba(105, 105, 95, 1);
        @define-color foreground rgba(0, 0, 0, .8);

        * {
            border: 0;
            font-family: "JetBrains Mono NerdFont";
            font-size: 14px;
        }



        /* Make the waybar background transparent */
        window#waybar {
            background: transparent;
            color: lighter(@foreground);
        }

        /* For modules that should have backgrounds and rounded corners */
        #workspaces,
        #window,
        #clock,
        #tray, 
        #wireplumber, 
        #network, 
        #wireplumber, 
        #custom-spotify, 
        #custom-mail, 
        #pulseaudio, 
        #hyprland-window,
        #system,
        #custom-notification {
            background: alpha(@background, 0.8);
            color: lighter(@secondary); 
            border-radius: 8px;
            padding: 0px 10px;
        }

        #cpu,
        #disk,
        #temperature,
        #memory {
            margin: 0px 6px;
        }

        menu,
        tooltip {
            border-radius: 8px;
            padding: 2px;
            border: 1px solid @foreground;
            background: alpha(@background, 0.6);
            color: lighter(@primary);
        }

        menu label,
        tooltip label {
            font-size: 12px;
            color: lighter(@primary);
        }



        #workspaces button {
            box-shadow: none;
            text-shadow: none;
            padding: 0px;
            margin-top: 4px;
            margin-bottom: 4px;
            margin-left: 0px;
            padding-left: 4px;
            padding-right: 4px;
            margin-right: 0px;
            color: @secondary;
            animation: ws_normal 20s ease-in-out 1;
        }

        #workspaces button.active {
            background: alpha(@primary, 0.8);
            color: @secondary;
            box-shadow: 0 0 0 2px @secondary;
            margin-left: 4px;
            padding-left: 16px;
            padding-right: 16px;
            margin-right: 4px;
            animation: ws_active 20s ease-in-out 1;
            transition: all 0.4s cubic-bezier(0.55, -0.68, 0.48, 1.682);
        }

        #workspaces button.urgent {
            font-weight: bold;
            color: @foreground;
        }

        #window {
            color: @foreground;
            background: @primary;
            font-weight: bold;
            border-radius: 8px
        }
        #clock {
            color: @foreground;
            background: @primary;
            font-weight: bold;
            border-radius: 8px
        }'';

      settings = {
        barbottom = {
          layer = "bottom";
          position = "bottom";
          height = 34;
          margin = "5";
          spacing = 10;

          "modules-left" = [ "hyprland/workspaces" ];
          "modules-center" = [ "hyprland/window" ];
          "modules-right" = [
            "tray"
            "custom/spotify"
            "pulseaudio"
            "group/system"
            "temperature"
            "clock"
            "custom/notification"
          ];
        };

        clock = {
          interval = 1;
          format = "{:%H:%M - %Y-%m-%d}";
        };

        tray = {
          icon-size = 24;
          spacing = 5;
        };

        "hyprland/window" = {
          icon = true;
          format = " {}";
          separate-outputs = true;
          rewrite = {
            "(.*) — Mozilla Firefox" = "$1 󰈹";
            "(.*)Mozilla Firefox" = "$1 Firefox 󰈹";
            "(.*) - Visual Studio Code" = "$1 󰨞";
            "(.*)Visual Studio Code" = "$1 Code 󰨞";
            "(.*) — Dolphin" = "$1 󰉋";
            "(.*)Spotify.*" = "$1 Spotify 󰓇";
            "(.*)Steam" = "$1 Steam 󰓓";
            "(.*) - Discord" = "$1  ";
            "(.*?)-\\s*YouTube(.*)" = "$1󰗃";
            "(.*?\\s)YouTube(.*)" = "$1YouTube 󰗃";
          };
          max-length = 50;
        };

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          active-only = false;
          on-click = "activate";
          on-scroll-up = "hyprctl dispatch workspace -1";
          on-scroll-down = "hyprctl dispatch workspace +1";
          persistent-workspaces = { };
          format = " {name} ";
        };

        "custom/notification" = {
          tooltip = false;
          format = "{} {icon}";
          format-icons = {
            notification = "";
            none = "";
            dnd-notification = "";
            dnd-none = "";
            inhibited-notification = "";
            inhibited-none = "";
            dnd-inhibited-notification = "";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        programs.waybar.settings = {
          "group/system" = {
            orientation = "horizontal";
            modules = [
              "disk"
              "cpu"
              "custom/cpu_temp"
              "custom/gpu_power"
              "custom/gpu_temp"
              "memory"
            ];
          };

          memory = {
            states = {
              c = 90; # critical
              h = 60; # high
              m = 30; # medium
            };
            interval = 30;
            format = "󰾆 {used}GB";
            format-m = "󰾅 {used}GB";
            format-h = "󰓅 {used}GB";
            format-c = " {used}GB";
            format-alt = "󰾆 {percentage}%";
            max-length = 10;
            tooltip = true;
            tooltip-format = ''
              󰾆 {percentage}%
               {used:0.1f}GB/{total:0.1f}GB'';
          };

          disk = {
            intervel =
              30; # (typo from original preserved, consider fixing to `interval`)
            format = "󰋊 {percentage_used}%";
            tooltip-format =
              ''{used} used out of {total} on "{path}" ({percentage_used}%)'';
          };

          cpu = {
            interval = 10;
            format = " {usage}%";
          };

          "custom/cpu_temp" = {
            exec = "sensors | grep 'Tctl' | awk '{print $2}'";
            interval = 2;
            format = " {} ";
            tooltip = true;
          };

          "custom/gpu_power" = {
            exec =
              "sensors | awk '/amdgpu-pci-0f00/,/PPT/ {if ($1==\"PPT:\") print $2, $3}'";
            interval = 2;
            format = "󰢮 {} ";
            tooltip = true;
          };

          "custom/gpu_temp" = {
            exec = "sensors | grep 'edge' | awk '{print $2}'";
            interval = 2;
            format = " {} ";
            tooltip = true;
          };
        };

      };
    };
  };
}
