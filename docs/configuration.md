# Configuration Guide

How to customize the system: add packages, configure services, and modify settings.

## Adding Packages

Edit `hosts/howard/default.nix` and add packages to `environment.systemPackages`:

```nix
environment.systemPackages = with pkgs; [
  # Existing packages...
  git
  neovim
  # Add new packages here
  firefox
  vlc
];
```

### Using Unstable Packages

The flake includes `nixpkgs-unstable`. To use an unstable package:

```nix
# In default.nix, the specialArgs already provide pkgs-unstable
environment.systemPackages = with pkgs-unstable; [
  some-package
];
```

## Enabling Services

Most services have an `enable` option:

```nix
services.serviceName = {
  enable = true;
  # service-specific settings
};
```

### Common Services

| Service | Enable Option |
|---------|--------------|
| SSH | `services.openssh.enable` |
| Tailscale | `services.tailscale.enable` |
| TLP | `services.tlp.enable` |
| fwupd | `services.fwupd.enable` |

## Network Configuration

Static IP is configured in `hosts/howard/default.nix`:

```nix
systemd.network = {
  enable = true;
  networks."10-eth0" = {
    matchConfig.Name = "enp1s0";
    networkConfig = {
      Address = [ "192.168.1.10/24" ];
      Gateway = "192.168.1.1";
      DNS = [ "192.168.1.1" "1.1.1.1" "8.8.8.8" ];
    };
  };
};
```

To modify: change the interface name (`enp1s0`), IP address, gateway, or DNS servers.

## Firewall

```nix
networking.firewall.enable = true;
networking.firewall.allowedTCPPorts = [ 22 80 443 ];
networking.firewall.allowedUDPPorts = [ 51820 ];
```

## SSH Keys

SSH public keys are stored in `hosts/howard/keys`. The path is configured in `default.nix`:

```nix
openssh.authorizedKeys.keyFiles = [ ./keys ];
```

To add a new key, simply append it to the `keys` file (one key per line).

## User Configuration

Add or modify users in `default.nix`:

```nix
users.users.username = {
  isNormalUser = true;
  description = "Full Name";
  extraGroups = [ "wheel" "networkmanager" ];
  openssh.authorizedKeys.keyFiles = [ ./keys ];
};
```

## Timezone and Locale

```nix
time.timeZone = "America/New_York";
i18n.defaultLocale = "en_US.UTF-8";
```

## Testing Changes

After making changes:

```bash
sudo nixos-rebuild dry-build --flake .#howard
```

If successful, apply with:

```bash
sudo nixos-rebuild switch --flake .#howard
```
