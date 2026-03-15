# Howard NixOS Configuration

NixOS flake-based system configuration for the "howard" machine.

## Project Structure

```
.
├── flake.nix              # Flake entry point
├── flake.lock             # Locked dependencies
├── AGENTS.md              # Agent guidelines
└── hosts/
    └── howard/
        ├── default.nix           # Main system configuration
        ├── hardware-configuration.nix  # Auto-generated (do not edit)
        └── config/
            ├── starship/
            │   ├── starship.nix   # Starship module
            │   └── starship.toml  # Starship settings
            └── zsh/
                ├── zsh.nix        # Zsh NixOS module
                ├── .zshenv        # Zsh environment
                ├── .zshrc         # Zsh interactive config
                ├── user.zsh       # User customizations
                ├── prompt.zsh     # Prompt config
                ├── plugin.zsh     # Plugin setup
                ├── conf.d/        # HyDE configs
                ├── functions/     # Custom functions
                └── completions/   # Custom completions
```

## Quick Start

```bash
# Build and switch
sudo nixos-rebuild switch --flake .#howard

# Dry-run to test changes
sudo nixos-rebuild dry-build --flake .#howard
```

## Updating

```bash
# Update flake inputs
sudo nix flake update

# Rebuild after update
sudo nixos-rebuild switch --flake .#howard
```

## System Details

- **Hostname**: howard
- **Static IP**: 192.168.1.10/24
- **Shell**: zsh (with HyDE + starship)
- **User**: ali

## Key Services

- SSH (port 22)
- Tailscale (port 51820/UDP)
- TLP (power management)
- fwupd (firmware updates)

## Files to Customize

| File | Purpose |
|------|---------|
| `hosts/howard/default.nix` | Main system config |
| `hosts/howard/config/zsh/user.zsh` | Zsh user customizations |
| `hosts/howard/config/zsh/prompt.zsh` | Prompt configuration |
| `hosts/howard/config/zsh/plugin.zsh` | Zsh plugins |

## Notes

- Never edit `hardware-configuration.nix` - it's auto-generated
- Keep `flake.lock` committed for reproducible builds
- SSH keys are stored in `/home/ali/system-config/hosts/howard/keys`
