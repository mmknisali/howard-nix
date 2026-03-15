# Troubleshooting

Solutions for common issues.

## Impure Evaluation Error

### Symptom
```
error: access to absolute path '/home/ali/system-config/hosts/howard/keys' is forbidden in pure evaluation mode
```

### Cause
`nix eval` runs in pure mode by default, which doesn't allow access to absolute paths outside the flake.

### Solution

**Option 1: Use `--impure` flag**
```bash
nix eval --impure .#nixosConfigurations.howard.config.system.build.toplevel.drvPath
```

**Option 2: Use nixos-rebuild (recommended)**
```bash
# nixos-rebuild automatically uses impure mode
sudo nixos-rebuild dry-build --flake .#howard
sudo nixos-rebuild switch --flake .#howard
```

## Path Does Not Exist

### Symptom
```
error: path '/home/ali/system-config/hosts/howard/keys' does not exist
```

### Cause
The SSH keys path configured in `default.nix` points to a non-existent location.

### Solution
1. Check where your SSH keys actually are
2. Update the path in `hosts/howard/default.nix`:

```nix
openssh.authorizedKeys.keyFiles = [ /path/to/your/keys ];
```

Or use a relative path:
```nix
openssh.authorizedKeys.keyFiles = [ ./keys ];
```

## Nixpkgs Channel Issues

### Symptom
```
error: cannot import path ... because it lacks a valid Nix store signature
```

### Solution
```bash
# Clean the Nix store
sudo nix-store --gc

# Or run with relaxed trust
nix --accept-flake-config --experimental-features "nix-command flakes" build .#nixosConfigurations.howard.config.system.build.toplevel
```

## Build Fails with Unfree Package

### Symptom
```
error: package 'some-package' is not allowed
```

### Solution
Enable unfree packages in `default.nix`:

```nix
nixpkgs.config.allowUnfree = true;
```

## Service Fails to Start

### Check Service Status
```bash
sudo systemctl status service-name
```

### Check Logs
```bash
sudo journalctl -u service-name -n 50
```

### Common Services
| Service | Command |
|---------|---------|
| SSH | `systemctl status sshd` |
| Tailscale | `systemctl status tailscale` |
| TLP | `systemctl status tlp` |

## Rollback

If something breaks, rollback to previous generation:

```bash
# List generations
sudo nix-env --list-generations -p /nix/var/nix/profiles/system

# Rollback
sudo nixos-rebuild switch --rollback
```

## Need More Help?

1. Check the NixOS manual: https://nixos.org/manual/nixos/stable/
2. Search NixOS options: https://search.nixos.org/options
3. Check the architecture guide: [architecture.md](./architecture.md)
