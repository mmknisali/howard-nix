# AGENTS.md - Howard NixOS Configuration

This repository contains a NixOS flake-based system configuration for the "howard" machine.

## Project Structure

```
.
├── flake.nix                    # Flake entry point
├── flake.lock                   # Locked dependencies
└── hosts/
    └── howard/
        ├── default.nix          # Main system configuration
        ├── hardware-configuration.nix  # Auto-generated hardware config
        └── config/
            └── starship/
                ├── starship.nix  # Starship module
                └── starship.toml # Starship settings
```

## Build Commands

### Building the System

```bash
# Build the NixOS system (dry-run)
sudo nix build .#nixosConfigurations.howard.config.system.build.toplevel --dry-run

# Build and switch to the new configuration
sudo nixos-rebuild switch --flake .#howard

# Build without switching (for testing)
sudo nixos-rebuild build --flake .#howard
```

### Testing Changes

```bash
# Evaluate the configuration (quick syntax check)
nix eval .#nixosConfigurations.howard.config.system.build.toplevel.drvPath --json

# Check for configuration errors
sudo nixos-rebuild dry-build --flake .#howard

# Dry-run rebuild
sudo nixos-rebuild dry-run --flake .#howard
```

### Flake Commands

```bash
# Update flake inputs (nixpkgs)
sudo nix flake update

# Show flake outputs
nix flake show

# Lock flake inputs
nix flake lock
```

## Code Style Guidelines

### General Principles

- Follow the Nix language conventions used in this repository
- Use idiomatic NixOS module syntax (`{ config, lib, pkgs, ... }:`)
- Keep configurations declarative and modular

### File Organization

- Host-specific configurations go in `hosts/<hostname>/`
- Modular configurations in `hosts/<hostname>/config/<module>/`
- Hardware configuration is auto-generated; do not manually edit
- Use `imports` to include other Nix files

### Nix Language Conventions

```nix
# Use let bindings for readability
let
  foo = "bar";
  baz = [ "a" "b" ];
in
{
  # Use 2-space indentation
  # Use camelCase for attribute names (NixOS convention)
  boot.loader.grub.enable = true;
  
  # Boolean attributes: prefer short form
  networking.firewall.enable = true;
  
  # Lists: one element per line for multi-element lists
  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];
}
```

### Naming Conventions

- Use kebab-case for file names: `starship.nix`, `hardware-configuration.nix`
- Use camelCase for Nix attribute names: `boot.loader.grub.enable`
- Use descriptive, lowercase names for variables
- Follow NixOS module naming: `<service>.enable`, `<service>.settings`

### Imports and Modules

- Always import `hardware-configuration.nix` in host configs
- Group related settings in logical sections with comments
- Use lib helpers: `lib.mkDefault`, `lib.mkForce`, `lib.mkIf`

### Error Handling

- Use assertions for required configuration: `assertions = [ ... ];`
- Use options with sensible defaults via `lib.mkDefault`
- Provide meaningful error messages in assertions

### Packages

- Add user packages to `environment.systemPackages`
- Prefer using `pkgs.` attribute path (e.g., `pkgs.git`)
- Group packages by category with comments

### Services Configuration

- Follow the service module's option naming
- Use `enable = true` to enable services
- Configure settings under the service's `settings` attribute when available
- Check NixOS options search for correct option paths

### Working with Flakes

- Always use `nixpkgs.url` with version/channel (e.g., `nixos-24.11`)
- Include both stable and unstable inputs when needed
- Use `legacyPackages` for accessing packages from inputs
- Keep flake.lock committed for reproducible builds

### Best Practices

1. **Never modify hardware-configuration.nix** - it's auto-generated
2. **Use `--flake .#howard`** for all nixos-rebuild commands
3. **Test changes with dry-run** before applying
4. **Commit flake.lock** to ensure reproducible builds
5. **Keep secrets out of config** - use keyFiles or secrets management

### Common Operations

```bash
# Add a new package
# Edit hosts/howard/default.nix and add to environment.systemPackages

# Add a new service
# Import the module in hosts/howard/default.nix and configure

# Enable a module option
# services.foo.enable = true;

# Set a package version from unstable
# pkgs-unstable.packageName
```

## Editor Support

For Nix language server support, add to your Neovim config:
- `nix-language-server` or `nil_ls` (Nix LSP)
- Tree-sitter for Nix syntax highlighting
