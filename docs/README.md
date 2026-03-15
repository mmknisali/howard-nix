# Howard NixOS Documentation

NixOS flake-based system configuration for the "howard" machine.

## Quick Links

| Task | Guide |
|------|-------|
| First time setup | [Getting Started](./getting-started.md) |
| Add packages or services | [Configuration](./configuration.md) |
| Customize zsh prompt/plugins | [Zsh Customization](./zsh-customization.md) |
| Fix build errors | [Troubleshooting](./troubleshooting.md) |
| Understand the codebase | [Architecture](./architecture.md) |

## System Overview

| Property | Value |
|----------|-------|
| Hostname | `howard` |
| Static IP | `192.168.1.10/24` |
| Shell | zsh (HyDE + starship) |
| User | `ali` |
| Nixpkgs | `nixos-24.11` |

## Key Services

- **SSH** - Port 22
- **Tailscale** - Port 51820/UDP
- **TLP** - Power management
- **fwupd** - Firmware updates

## Common Commands

```bash
# Build and apply changes
sudo nixos-rebuild switch --flake .#howard --impure

# Test changes without applying
sudo nixos-rebuild dry-build --flake .#howard --impure

# Update nixpkgs
sudo nix flake update
```

## Project Structure

```
howard-nix/
├── flake.nix              # Flake entry point
├── flake.lock             # Locked dependencies
├── AGENTS.md              # Guidelines for AI agents
└── hosts/howard/
    ├── default.nix        # Main system configuration
    ├── keys               # SSH public keys
    ├── hardware-configuration.nix  # Auto-generated (don't edit)
    └── config/
        ├── starship/      # Prompt configuration
        └── zsh/           # Zsh configuration
```

## Contributing

1. Make changes to config files
2. Test with `sudo nixos-rebuild dry-build --flake .#howard`
3. Apply with `sudo nixos-rebuild switch --flake .#howard`
4. Commit and push
