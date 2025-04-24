{ lib, pkgs, config , ... }:
let
  inherit (lib)
  mkIf mkEnableOption mkPackageOption mkOption;

  cfg = config.programs.onedrive;

  formatter = pkgs.formats.keyValue { indent = " "; };
in 
{
  options.programs.onedrive = {
    enable = mkEnableOption "onedrive";
    package = mkPackageOption pkgs "onedrive" { nullable = true; };
    settings = mkOption {
      type = formatter.type;
      default = { };
      example = ''
        {
          check_nomount = "false";
          check_nosync = "false";
          classify_as_big_delete = "1000";
          cleanup_local_files = "false";
          disable_notifications = "false";
          no_remote_delete = "false";
          rate_limit = "0";
          resync = "false";
          skip_dotfiles = "false";
        }
      '';
      description = ''
        Configuration settings for Onedrive. All available options can be
        found at <https://github.com/abraunegg/onedrive/blob/master/config>.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.packages ];

    xdg.configFile = mkIf (cfg.settings != { }) {
      "onedrive/config".source = (formatter.generate "onedrive_config" cfg.settings);
    };
  };
}
