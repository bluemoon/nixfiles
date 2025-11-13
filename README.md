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

Packages are defined in `modules/home.nix` under `home.packages`. These include:

- Development tools (ripgrep, fd, tree-sitter, etc.)
- Language servers (rust-analyzer, rnix-lsp, lua-language-server)
- CLI utilities (bat, exa, fzf, zoxide)

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
