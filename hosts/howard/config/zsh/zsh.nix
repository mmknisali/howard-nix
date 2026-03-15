{ config, lib, pkgs, ... }:

{
  options = {
    hydeZsh = {
      enable = lib.mkEnableOption "Enable HyDE zsh configuration";
      source = lib.mkOption {
        type = lib.types.path;
        description = "Path to the zsh configuration directory";
      };
    };
  };

  config = lib.mkIf config.hydeZsh.enable {
    environment.etc."zsh".source = config.hydeZsh.source;

    environment.sessionVariables = {
      ZDOTDIR = "/etc/zsh";
    };

    programs.zsh = {
      enable = true;
      promptInit = lib.mkDefault "";
    };
  };
}
