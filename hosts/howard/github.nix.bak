# modules/github-runner.nix
{ config, pkgs, lib, ... }:
{
  services.github-runners.howard-runner = {
    enable = true;
    name = "howard-runner";
    url = "https://github.com/mmknisali/site";
    tokenFile = "/etc/github-runner/token";
    ephemeral = false;
    extraLabels = [ "howard" ];
    extraPackages = with pkgs; [
      nodejs_22 sqlite cloudflared gh git curl psmisc procps
    ];
    user = "ali";
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/github-runner/howard-runner 0750 ali ali -"
  ];
}
