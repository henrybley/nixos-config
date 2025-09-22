{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.features.misc.rclone;
in
{
  options.features.misc.rclone = {
    enable = mkEnableOption "Rclone auto mount system";
  };

  config = mkIf cfg.enable {

    home = {
      packages = [ pkgs.rclone ];
      shellAliases = {
        "reload-rclone" = "systemctl --user restart rCloneMounts.service";
      };
    };

    systemd.user.services.rCloneMounts = {
      Unit = {
        Description = "Mount all rClone configurations";
        After = [ "network-online.target" ];
      };

      Service =
        let
          home = config.home.homeDirectory;
        in
        {
          Type = "forking";
          ExecStartPre = "${pkgs.writeShellScript "rClonePre" ''
            remotes=$(${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone.conf listremotes)
            for remote in $remotes;
            do
            name=$(/usr/bin/env echo "$remote" | /usr/bin/env sed "s/://g")
            /usr/bin/env mkdir -p ${home}/"$name"
            done
          ''}";

          ExecStart = "${pkgs.writeShellScript "rCloneStart" ''
            remotes=$(${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone.conf listremotes)
            for remote in $remotes;
            do
            name=$(/usr/bin/env echo "$remote" | /usr/bin/env sed "s/://g")
            ${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone.conf --vfs-cache-mode writes --ignore-checksum mount "$remote" "$name" &
            done
          ''}";

          ExecStop = "${pkgs.writeShellScript "rCloneStop" ''
            remotes=$(${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone.conf listremotes)
            for remote in $remotes;
            do
            name=$(/usr/bin/env echo "$remote" | /usr/bin/env sed "s/://g")
            /usr/bin/env fusermount -u ${home}/"$name"
            done
          ''}";
        };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
