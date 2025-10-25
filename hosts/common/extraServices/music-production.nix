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
  
  config = mkIf cfg.enable {
    # Musnix configuration - always enabled when music-production is enabled
    musnix = {
      enable = true;
      kernel.realtime = true;
      das_watchdog.enable = true;
      rtirq.enable = true;
    };
    
    environment.systemPackages = with pkgs; [
      # DAW
      bitwig-studio
      
      # VST Support
      yabridge # For running Windows VSTs on Linux
      wine # Required for yabridge
      winetricks # Wine configuration helper
      
      # Native Linux VSTs and Synthesizers
      vital # Vital wavetable synthesizer (from nixpkgs!)
      #surge-XT # Another excellent wavetable synth
      cardinal # VCV Rack fork
      
      # Effects and Processing
      calf # Comprehensive plugin suite
      lsp-plugins # Professional audio plugins
      x42-plugins # Collection of LV2 plugins
      zam-plugins # High-quality audio plugins
      
      # Audio utilities
      qjackctl # JACK control GUI (works with PipeWire's JACK layer)
      helvum # PipeWire graph editor
      pavucontrol # PulseAudio volume control (works with PipeWire)
      
      # Plugin hosts and utilities
      carla # Plugin host and rack
      jalv # Simple LV2 host
      
      # Audio analysis and utilities
      sonic-visualiser # Audio analysis tool
    ];
    
    # Enhanced environment variables for plugin discovery
    environment.variables = {
      # Use mkDefault to allow other modules to override these paths
      DSSI_PATH = mkDefault (makePluginPath "dssi");
      LADSPA_PATH = mkDefault (makePluginPath "ladspa");
      LV2_PATH = mkDefault (makePluginPath "lv2");
      LXVST_PATH = mkDefault (makePluginPath "lxvst");
      VST_PATH = mkDefault (makePluginPath "vst");
      VST3_PATH = mkDefault (makePluginPath "vst3");
      CLAP_PATH = mkDefault (makePluginPath "clap"); # For future CLAP plugin support
    };
    
    # Additional audio-specific system configuration
    # (These complement musnix but are also useful without it)
    security.pam.loginLimits = [
      { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
      { domain = "@audio"; item = "rtprio"; type = "-"; value = "95"; }
      { domain = "@audio"; item = "nofile"; type = "soft"; value = "99999"; }
      { domain = "@audio"; item = "nofile"; type = "hard"; value = "99999"; }
    ];
    
    # Ensure audio group exists and has proper permissions
    users.groups.audio = {};
    
    # Optional: Add current user to audio group automatically
    # users.users.${config.users.users.*.name}.extraGroups = [ "audio" ];
    
    # System-level optimizations are handled by musnix
    # No additional kernel params needed
    
    # CPU governor for consistent performance
    powerManagement.cpuFreqGovernor = "performance";
    
    # Additional services that can help with audio production
    services.udev.extraRules = ''
      # Increase priority for audio interfaces
      SUBSYSTEM=="usb", ATTRS{idVendor}=="*", ATTRS{idProduct}=="*", TAG+="uaccess"
      # Add more specific rules for your audio interface if needed
    '';
  };
}
