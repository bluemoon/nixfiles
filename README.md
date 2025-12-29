# nixfiles for OSX

## Installation

1. Install XCode CLI tools

   ```
   xcode-select --install
   ```

2. Install Nix (a reboot could be necessary)

   ```
   sh <(curl -L https://nixos.org/nix/install)
   ```

3. Enable flakes and nix-command:

   ```bash
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

4. Clone this repo inside `~/.config/nixpkgs` (must remove default nixpkgs before cloning)

   ```
   rm -r ~/.config/nixpkgs
   git clone git@github.com:bluemoon/nixfiles.git ~/.config/nixpkgs
   ```

5. Install the flake (choose the host that matches the machine)

   ```
   cd ~/.config/nixpkgs
   nix build .#darwinConfigurations.bradford-mbp.system
   ./result/sw/bin/darwin-rebuild switch --flake .#bradford-mbp
   ```

   On the Mac Studio, swap the host key:

   ```
   nix build .#darwinConfigurations.bradford-macstudio.system
   ./result/sw/bin/darwin-rebuild switch --flake .#bradford-macstudio
   ```

6. Install Homebrew

   ```
   bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
   ```

7. Install apps from Homebrew
   > NOTEs:
   >
   > - Takes a **loooong** time
   > - **Will ask for password a lot of times...**
   ```
   brew bundle --verbose --file ~/.config/nixpkgs/macos/Brewfile
   ```

---

## System Architecture

- **Nix Darwin**: System-level macOS configuration
- **Home Manager**: User-level dotfiles and package management
- **Flakes**: Reproducible configuration with pinned dependencies

## Configuration Structure

```
~/.config/nixpkgs/
├── flake.nix                 # Main flake configuration
├── flake.lock               # Locked dependencies
├── modules/
│   ├── home.nix            # Home-manager configuration
│   ├── mac.nix             # macOS system configuration
│   ├── pam.nix             # PAM configuration for TouchID
│   └── home-manager/       # Individual program configs
│       ├── alacritty.nix
│       ├── fish.nix
│       ├── neovim.nix      # Neovim configuration
│       └── tmux.nix
├── programs/               # Program configurations
│   └── neovim/            # Neovim lua config files
└── macos/
    └── Brewfile           # Homebrew packages
```

## Common Operations

### Switch Between Hosts

Each machine has its own darwin configuration inside the flake. Run the rebuild command with the matching host key:

```bash
darwin-rebuild switch --flake .#bradford-mbp          # Laptop
darwin-rebuild switch --flake .#bradford-macstudio    # Mac Studio
```

### Update Configuration

After making changes to any `.nix` files:

```bash
darwin-rebuild switch --flake .#<host>
```

### Update All Dependencies

```bash
# Update flake inputs
nix flake update

# Apply changes
darwin-rebuild switch --flake .#<host>
```

### Add a New Package

1. Edit `modules/home.nix`
2. Add package to `home.packages` list
3. Run `darwin-rebuild switch --flake .#<host>`

### Modify Program Configuration

1. Edit the relevant file in `modules/home-manager/`
2. Run `darwin-rebuild switch --flake .#<host>`

## Package Management

### System Packages (via Nix)

Packages are defined in `modules/home.nix` under `home.packages`.

#### CLI Toolkit

##### Shell

| Tool | Description |
|------|-------------|
| fish | Modern shell with autosuggestions and syntax highlighting |
| starship | Fast, customizable prompt written in Rust |
| atuin | SQLite-backed shell history with fuzzy search (Ctrl+R) |
| pay-respects | Fix previous command with `f` (thefuck replacement) |
| tldr | Simplified man pages with examples |
| tmux | Terminal multiplexer for sessions/windows/panes |

##### Monitoring

| Tool | Description |
|------|-------------|
| btop | Resource monitor (CPU, mem, disk, network) |
| procs | Modern `ps` replacement with color and tree view |
| duf | Disk usage (`df` replacement) with nice output |
| dust | Disk usage analyzer (`du` replacement) with tree view |
| bandwhich | Bandwidth monitor by process/connection |

##### Navigation & Search

| Tool | Description |
|------|-------------|
| yazi | Terminal file manager with image preview |
| zoxide | Smarter `cd` that learns your habits (`z foo`) |
| fzf | Fuzzy finder for files, history, everything |
| eza | Modern `ls` with git status and icons |
| ripgrep | Fast grep replacement (`rg pattern`) |
| fd | Fast find replacement (`fd pattern`) |
| bat | Cat with syntax highlighting and git diff |
| ast-grep | Structural code search using AST patterns |

##### Git

| Tool | Description |
|------|-------------|
| lazygit | Terminal UI for git |
| delta | Syntax-highlighting pager for git diffs |
| difftastic | Structural diff that understands syntax |

##### Editor

| Tool | Description |
|------|-------------|
| neovim | Hyperextensible vim (configured via nixvim) |

##### Network & HTTP

| Tool | Description |
|------|-------------|
| xh | HTTPie-like HTTP client in Rust |
| doggo | DNS client with nice output (`doggo example.com`) |
| grpcurl | Curl for gRPC services |
| curl | HTTP client |

##### Data

| Tool | Description |
|------|-------------|
| jq | JSON processor |
| yq | YAML/TOML processor (jq for YAML) |
| miller | CSV/JSON/etc swiss army knife |
| jless | Interactive JSON viewer |
| duckdb | In-process SQL OLAP database |
| gnuplot | Plotting and graphing utility |

##### Containers & Kubernetes

| Tool | Description |
|------|-------------|
| docker | Container runtime |
| colima | Docker Desktop alternative for macOS |
| lazydocker | Terminal UI for docker |
| k9s | Terminal UI for Kubernetes |
| kubectl | Kubernetes CLI |
| skopeo | Container image operations |
| fluxcd | GitOps for Kubernetes |

##### Dev Tools

| Tool | Description |
|------|-------------|
| hyperfine | Benchmarking tool (`hyperfine 'cmd1' 'cmd2'`) |
| tokei | Code statistics (lines of code by language) |
| watchexec | Run command on file changes |

##### Security

| Tool | Description |
|------|-------------|
| age | Modern file encryption |
| sops | Secrets management for config files |
| gnupg | GPG encryption |
| 1password-cli | 1Password CLI (`op`) |

##### Misc

| Tool | Description |
|------|-------------|
| glow | Markdown renderer in terminal |
| fastfetch | System info display (neofetch alternative) |
| direnv | Per-directory environment variables |

#### Languages & Runtimes

- **Rust**: rustup
- **Go**: go
- **Python**: uv, ruff, pyrefly
- **Node**: nodejs, pnpm, yarn
- **Zig**: zig
- **Ruby**: ruby
- **Lua**: luajit, stylua

#### AI Coding Assistants

- claude-code
- codex
- opencode

### Homebrew Packages

Some packages are still managed via Homebrew (defined in `macos/Brewfile`):

- GUI applications (Firefox, Spotify, Slack)
- macOS-specific tools (yabai, skhd)
- Fonts

To update Homebrew packages:

```bash
cd ~/.config/nixpkgs/macos
brew bundle
```

## Neovim Setup

Neovim is now managed entirely through Nix:

- Package: `neovim-nightly` from the neovim-overlay
- Configuration: Managed via home-manager
- Plugins: Still using Packer (auto-bootstrapped)
- Language servers: Installed via Nix packages

### First-time Neovim Setup

After switching to the new configuration:

1. Open Neovim: `nvim`
2. Run `:PackerSync` to install all plugins
3. Restart Neovim

## Troubleshooting

### "Command not found" after switching

Ensure your shell is sourcing the Nix environment:

```bash
# For fish shell
fish_add_path /nix/var/nix/profiles/default/bin
fish_add_path /run/current-system/sw/bin
fish_add_path ~/.nix-profile/bin
```

### Flake evaluation errors

Check for syntax errors:

```bash
nix flake check
```

### Permission denied during darwin-rebuild

Ensure nix-daemon is running:

```bash
sudo launchctl kickstart -k system/org.nixos.nix-daemon
```

### Neovim plugins not loading

1. Check if Packer is installed: `ls ~/.local/share/nvim/site/pack/packer/`
2. Run `:PackerSync` in Neovim
3. Check for errors: `:PackerStatus`

## Maintenance

### Regular Updates

```bash
# Update flake inputs monthly
nix flake update

# Check for outdated packages
nix-env -qa --compare-versions

# Garbage collection (remove old generations)
nix-collect-garbage -d
```

### Backup Important Files

Before major changes, backup:

- `flake.lock` - Current working dependencies
- Any local modifications to configs

## Notes

- The `result` symlink is created by nix build and can be safely deleted
- TouchID for sudo is enabled via `security.pam.enableSudoTouchIdAuth`
- The system uses `aarch64-darwin` for Apple Silicon compatibility

---

## References

1. https://github.com/shaunsingh/nix-darwin-dotfiles/blob/main/nix-config.org
