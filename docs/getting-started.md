# Getting Started

This guide covers cloning, building, and updating the system.

## Prerequisites

- Nix with flakes enabled
- sudo access on the target machine

## Clone the Repository

```bash
git clone https://github.com/yourusername/howard-nix.git
cd howard-nix
```

## Build the System

### Test Changes (Dry Build)

```bash
sudo nixos-rebuild dry-build --flake .#howard
```

This compiles the configuration without applying it. Use this to catch errors.

### Apply Changes

```bash
sudo nixos-rebuild switch --flake .#howard
```

This builds and activates the new system configuration.

### Build Without Switching

```bash
sudo nixos-rebuild build --flake .#howard
```

Builds the system but doesn't activate it. The result is in `/nix/var/nix/profiles/system`.

## Update Nixpkgs

```bash
# Update flake inputs to latest
sudo nix flake update

# Rebuild with new inputs
sudo nixos-rebuild switch --flake .#howard
```

## Quick Reference

| Command | Purpose |
|---------|---------|
| `nixos-rebuild switch` | Build and apply |
| `nixos-rebuild dry-build` | Test without applying |
| `nixos-rebuild build` | Build only |
| `nix flake update` | Update nixpkgs |
| `nix flake show` | Show available outputs |

## First-Time Setup

If this is a fresh install:

1. Generate hardware config:
   ```bash
   sudo nixos-generate-config --root /mnt
   ```

2. Copy the generated `hardware-configuration.nix` to `hosts/howard/`

3. Update the NixOS configuration as needed

4. Run `sudo nixos-install --flake .#howard`

## Evaluating Configuration

To quickly check if your config parses correctly:

```bash
# Requires --impure because of absolute paths (SSH keys)
nix eval --impure .#nixosConfigurations.howard.config.system.build.toplevel.drvPath
```

Note: `nixos-rebuild` automatically uses impure mode, so this is only needed for quick syntax checks.
