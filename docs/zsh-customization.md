# Zsh Customization

This guide explains which file to edit for different zsh customizations.

## Configuration Files

| File | Purpose | Edit This? |
|------|---------|------------|
| `user.zsh` | User customizations | **YES** |
| `prompt.zsh` | Prompt configuration | **YES** |
| `plugin.zsh` | Plugin setup | **YES** |
| `.zshrc` | Interactive shell config | **YES** |
| `conf.d/hyde/*` | HyDE system files | NO (auto-managed) |
| `functions/*` | Custom functions | As needed |
| `completions/*` | Tab completions | As needed |

## Quick Customization

### Add Aliases

Edit `hosts/howard/config/zsh/.zshrc`:

```zsh
alias ll='eza -lha --icons'
alias myalias='command to run'
```

### Set Environment Variables

Edit `hosts/howard/config/zsh/.zshrc`:

```zsh
export EDITOR=nvim
export PATH="$PATH:/custom/path"
```

### Customize Prompt

The system uses **starship** by default. Edit `hosts/howard/config/starship/starship.toml` for prompt customization.

To use a different prompt:

1. Edit `hosts/howard/config/zsh/prompt.zsh`
2. Comment out `return 1` 
3. Add your prompt config

Example using starship:
```zsh
# In prompt.zsh
eval "$(starship init zsh)"
export STARSHIP_CACHE=$XDG_CACHE_HOME/starship
export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship/starship.toml
```

### Add Zsh Plugins

Edit `hosts/howard/config/zsh/user.zsh`:

```zsh
# Add OMZ plugins here
plugins=(
    git
    docker
    kubectl
)
```

Or enable the zinit plugin manager in `plugin.zsh`:
1. Remove/comment `return 1` at the top
2. Add your zinit plugins

## HyDE Variables

Set these in `user.zsh` to control HyDE:

```zsh
# Disable OMZ plugins
HYDE_ZSH_NO_PLUGINS=1

# Disable HyDE prompt
unset HYDE_ZSH_PROMPT

# Skip compinit security check (faster startup)
HYDE_ZSH_COMPINIT_CHECK=1

# Defer OMZ loading
HYDE_ZSH_OMZ_DEFER=1
```

## Adding Custom Functions

Create a new file in `hosts/howard/config/zsh/functions/`:

```zsh
# hosts/howard/config/zsh/functions/myfunction.zsh
myfunction() {
    echo "Hello from custom function"
}
zle -N myfunction
bindkey '^g' myfunction
```

## Testing Zsh Changes

After editing zsh config:

```bash
# Rebuild system
sudo nixos-rebuild switch --flake .#howard

# Or test in current shell
source ~/.zshrc
```

## File Locations After Build

The zsh config is copied to `/etc/zsh/` on the system:

- `/etc/zsh/.zshenv` 
- `/etc/zsh/.zshrc`
- `/etc/zsh/conf.d/`
- etc.

The `ZDOTDIR` environment variable is set to `/etc/zsh`.
