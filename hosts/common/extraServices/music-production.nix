{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.extraServices.music-production;
  
  # Helper function for plugin paths (from musnix documentation)
  makePluginPath = format:
    (makeSearchPath format [
      "$HOME/.nix-profile/lib"
      "/run/current-system/sw/lib"
      "/etc/profiles/per-user/$USER/lib"
    ])
    + ":$HOME/.${format}";
in
{
  options.extraServices.music-production = {
    enable = mkEnableOption "Enable Music Production";
  };
  
  config = mkMerge [
    (mkIf cfg.enable {
      # Only set musnix options if musnix module is available
      # This will silently do nothing if musnix isn't imported
      musnix = mkIf (hasAttr "musnix" options) {
        enable = true;
        kernel.realtime = true;
        das_watchdog.enable = true;
        rtirq.enable = true;
      };
      
      environment.systemPackages = with pkgs; [
        # DAW
        bitwig-studio
        
        # VST Support
        yabridge
        wine
        winetricks
        
        # Native Linux VSTs and Synthesizers
        vital
        cardinal
        
        # Effects and Processing
        calf
        lsp-plugins
        x42-plugins
        zam-plugins
        
        # Audio utilities
        qjackctl
        helvum
        pavucontrol
        
        # Plugin hosts and utilities
        carla
        jalv
        
        # Audio analysis and utilities
        sonic-visualiser
      ];
      
      # Enhanced environment variables for plugin discovery
      environment.variables = {
        DSSI_PATH = mkDefault (makePluginPath "dssi");
        LADSPA_PATH = mkDefault (makePluginPath "ladspa");
        LV2_PATH = mkDefault (makePluginPath "lv2");
        LXVST_PATH = mkDefault (makePluginPath "lxvst");
        VST_PATH = mkDefault (makePluginPath "vst");
        VST3_PATH = mkDefault (makePluginPath "vst3");
        CLAP_PATH = mkDefault (makePluginPath "clap");
      };
      
      # Additional audio-specific system configuration
      security.pam.loginLimits = [
        { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
        { domain = "@audio"; item = "rtprio"; type = "-"; value = "95"; }
        { domain = "@audio"; item = "nofile"; type = "soft"; value = "99999"; }
        { domain = "@audio"; item = "nofile"; type = "hard"; value = "99999"; }
      ];
      
      # Ensure audio group exists and has proper permissions
      users.groups.audio = {};
      
      # CPU governor for consistent performance
      powerManagement.cpuFreqGovernor = "performance";
      
      # Additional services that can help with audio production
      services.udev.extraRules = ''
        # Increase priority for audio interfaces
        SUBSYSTEM=="usb", ATTRS{idVendor}=="*", ATTRS{idProduct}=="*", TAG+="uaccess"
      '';
    })
  ];
}
