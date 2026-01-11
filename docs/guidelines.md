# Nix Configuration Guidelines

## Build Commands
- `nixswitch` - Apply configurations to current system
- `nixup` - Update system packages and configurations
- `darwin-rebuild switch --flake .#bradford-mbp` - Build MBP config manually
- `darwin-rebuild switch --flake .#bradford-macstudio` - Build Mac Studio config manually

## Host Configurations

| Config Name | Machine | Username | Home Directory |
|-------------|---------|----------|----------------|
| `bradford-mbp` | MacBook Pro | `bradfordtoney` | `/Users/bradford` |
| `bradford-macstudio` | Mac Studio | `bradford` | `/Users/bradford` |

Each host writes its config name to `/etc/nix-host` for automatic detection.

## Code Style Guidelines
- **Imports**: Group imports at top of file, sorted alphabetically
- **Formatting**: Use `nixfmt-classic`, 2-space indentation, trailing commas in multi-line lists
- **Naming**: Use camelCase for variables, descriptive names for modules

## Module Structure
- `flake.nix` - Main entry point with host configurations
- `modules/mac.nix` - Darwin system configuration
- `modules/home.nix` - Home-manager configuration (shared)
- `modules/home-manager/` - Program-specific configs (fish.nix, tmux.nix)
- `modules/nixvim/` - Neovim configuration
- `pkgs/` - Custom package definitions

## Common Patterns

### Adding a package
Add to `home.packages` in `modules/home.nix`:
```nix
home.packages = [
  pkgs.some-package
];
```

### Adding a fish abbreviation
Add to `shellAbbrs` in `modules/home-manager/fish.nix`:
```nix
shellAbbrs = {
  abbr = "expanded command";
};
```

### Adding an SSH host
Add to `matchBlocks` in `modules/home.nix`:
```nix
programs.ssh.matchBlocks = {
  "hostname" = {
    hostname = "full.hostname.here";
    user = "username";
  };
};
```

### Host-specific config
Add in `flake.nix` under the specific `darwinConfigurations` entry, not in shared modules.

## Package Sources
- Prefer nixpkgs-unstable (already configured)
- Custom packages go in `pkgs/`
