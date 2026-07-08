# modules/github-runner.nix
{ config, pkgs, lib, inputs, ... }:
{
  services.github-runners.howard-runner = {
    enable = true;
    name = "howard-runner";
    url = "https://github.com/mmknisali/site";
    tokenFile = "/etc/github-runner/token";
    ephemeral = false;
    extraLabels = [ "howard" ];
    extraPackages = with pkgs; [
      nodejs_22 sqlite cloudflared gh git curl psmisc procps openssh
    ] ++ [ inputs.devenv.packages.x86_64-linux.default ];
    user = "ali";

    # The runner needs to read/write the deploy trees at
    # /home/ali/vertha-staging and /home/ali/vertha-prod. It also
    # needs to talk to the ali user's systemd instance via the DBUS
    # session bus at /run/user/1000/bus to manage vertha-staging and
    # vertha-prod systemd units.
    #
    # The NixOS module hardens the service with several namespace
    # restrictions that block this:
    #   - ProtectHome=true        hides /home, /root, /run/user
    #   - PrivateUsers=true       remaps the runner's UID to 0
    #                             inside a user namespace
    #   - PrivateMounts=true      hides host /run/user/1000/ from
    #                             the step process
    #   - ProtectSystem=strict    makes most of / read-only (fine
    #                             for us, but not the cause)
    #
    # The documented escape hatch is serviceOverrides (see
    # nixos/modules/services/continuous-integration/github-runner/options.nix).
    serviceOverrides = {
      ProtectHome = false;
      # Allow the step process to see /run/user/1000/ and use the
      # real ali UID (1000) so getent/grep on /etc/passwd and
      # XDG_RUNTIME_DIR=/run/user/1000 work correctly.
      PrivateUsers = false;
      PrivateMounts = false;
      # The runner still doesn't need its own /tmp; PrivateTmp=true
      # is fine (it has /run/user/<uid>/ inside the host /run/user).
      PrivateTmp = true;
    };
  };

  # The GitHub Actions runner (running as `ali`, in the `wheel` group)
  # needs to `systemctl restart cloudflared-staging` (and -production)
  # from a non-interactive job context. Polkit's default for
  # org.freedesktop.systemd1.manage-units requires interactive admin
  # auth, which the runner's process tree doesn't have. Grant the
  # specific rule below to allow the deploy script to manage the
  # cloudflared services.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units" &&
          (subject.user == "ali" || subject.user == "root")) {
        return polkit.Result.YES;
      }
    });
  '';

  # The cloudflared tunnel process is long-lived and must survive the
  # GitHub Actions runner job. We manage it via systemd instead of
  # nohup-ing it from the deploy script (which would be reaped when
  # the job ends, causing HTTP 530 from Cloudflare's edge).
  #
  # The deploy script writes the config file at
  # ${LOGS_DIR}/cloudflared-${ENV}.yml and then runs
  # `systemctl restart cloudflared-${ENV}`. Restart=always picks up
  # the new config and reconnects to Cloudflare's edge.
  #
  # The config file is written by the deploy, so the service may
  # fail to start on first boot (no config). Restart=always retries
  # every 5s; the first deploy will stabilize it.

  systemd.services.cloudflared-staging = {
    description = "Cloudflare Tunnel for staging.vertha.tech";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "exec";
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --config /home/ali/vertha-staging/logs/cloudflared-staging.yml run";
      Restart = "always";
      RestartSec = "5s";
      User = "ali";
      Group = "users";
      Environment = "HOME=/home/ali";
      WorkingDirectory = "/home/ali/vertha-staging";
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = "read-only";
      ReadWritePaths = [ "/home/ali/vertha-staging" ];
      PrivateTmp = true;
      PrivateDevices = true;
      PrivateUsers = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = false;
      SystemCallArchitectures = "native";
      UMask = "0027";
    };
  };

  systemd.services.cloudflared-production = {
    description = "Cloudflare Tunnel for vertha.tech";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "exec";
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --config /home/ali/vertha-prod/logs/cloudflared-production.yml run";
      Restart = "always";
      RestartSec = "5s";
      User = "ali";
      Group = "users";
      Environment = "HOME=/home/ali";
      WorkingDirectory = "/home/ali/vertha-prod";
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = "read-only";
      ReadWritePaths = [ "/home/ali/vertha-prod" ];
      PrivateTmp = true;
      PrivateDevices = true;
      PrivateUsers = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = false;
      SystemCallArchitectures = "native";
      UMask = "0027";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/github-runner/howard-runner 0750 ali ali -"
  ];
}
