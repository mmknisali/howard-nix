# Howard - NixOS Configuration

NixOS flake for headless homelab server.

## Deployment

### 1. Copy to server
```bash
scp -r hosts howard/ flake.nix ali@192.168.1.10:/etc/nixos/
```

### 2. SSH into server and generate hardware config (first time only)
```bash
ssh ali@192.168.1.10
cd /etc/nixos
sudo nixos-generate-config
```

### 3. Update hardware-configuration.nix
Copy the generated `/etc/nixos/hardware-configuration.nix` to `hosts/howard/hardware-configuration.nix`

### 4. Apply the flake
```bash
cd /etc/nixos
sudo nixos-rebuild switch --flake .#howard
```

### 5. Reboot
```bash
sudo reboot
```

## Post-install

### Authenticate Tailscale
```bash
sudo tailscale up
```

## Management

### Update system
```bash
cd /etc/nixos
sudo nixos-rebuild switch --flake .#howard
```

### View current generation
```bash
sudo nixos-rebuild list-generations
```

### Rollback
```bash
sudo nixos-rebuild switch --rollback
```
