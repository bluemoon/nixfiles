# nixfiles for OSX


## Installation

1. Install XCode CLI tools
    ```
    xcode-select --install
    ```

1. Install Nix (a reboot could be necessary)
    ```
    sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume
    ```
1. Add home-manager and unstable channels
    ```
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
    nix-channel --update
    export NIX_PATH=${NIX_PATH:+$NIX_PATH:}$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels    
    ```
1. Install home-manager
    ```
    nix-shell '<home-manager>' -A install
    ```
1. Install nix-darwin

    ```
    nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
    ./result/bin/darwin-installer
    ```
3. Clone this repo inside `~/.config/nixpkgs` (must remove default nixpkgs before cloning)
    ```
    rm -r ~/.config/nixpkgs
    git clone git@github.com:bluemoon/nixfiles.git ~/.config/nixpkgs
    ```
1. Setup home-manager configuration (install and configure programs)
    ```
    home-manager switch
    ```

1. Install Homebrew
    ```
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    ```
1. Install apps from Homebrew
    > NOTEs:
    >   - Takes a **loooong** time
    >   - **Will ask for password a lot of times...**
    ```
    brew bundle --verbose --file ~/.config/nixpkgs/macos/Brewfile
    ```

---

## References
1. https://github.com/shaunsingh/nix-darwin-dotfiles/blob/main/nix-config.org
