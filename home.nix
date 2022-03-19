{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "bradford";
  home.homeDirectory = "/Users/bradford";
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  # Better ls
  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  # FZF
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  # Enable ZSH
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    initExtra = ''
    export PATH=/Users/bradfordtoney/.cargo/bin:$HOME/go/bin:/usr/local/bin:/Users/bradfordtoney/.nix-profile/bin/:$PATH
    export PATH="$(yarn global bin):$PATH"
    eval "$(zoxide init zsh)"
    '';
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "command-not-found"
        "git"
        "history"
        "sudo"
        "fzf"
        "dotenv"
      ];
    };
    shellAliases = {
      k = "kubectl";
      vi = "nvim";
      vim = "nvim";
    };
  };

  
  programs.fish = {
    enable = true;
    loginShellInit = ''
      set -xg TERM xterm-256color
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      end
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      end
      if test -e $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
        fenv source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
      end

      set -xg PATH $HOME/bin $HOME/.cargo/bin $PATH
      set -xg PATH (yarn global bin) $PATH
    '';

    interactiveShellInit = ''
      eval (direnv hook fish)
      any-nix-shell fish --info-right | source
    '';
  };

  # Git config
  programs.git = {
    enable = true;
    userName = "Bradford Toney";
    userEmail = "bradford.toney@gmail.com";
    aliases = {
      st = "status";
    };
  };
  xdg.configFile."nvim/init.lua".source = programs/neovim/init.lua;
  xdg.configFile."nvim/lua/user/colorscheme.lua".source = programs/neovim/lua/user/colorscheme.lua;
  xdg.configFile."nvim/lua/user/options.lua".source = programs/neovim/lua/user/options.lua;
  xdg.configFile."nvim/lua/user/plugins.lua".source = programs/neovim/lua/user/plugins.lua;
  xdg.configFile."nvim/lua/user/lsp.lua".source = programs/neovim/lua/user/lsp.lua;
  xdg.configFile."nvim/lua/user/keymaps.lua".source = programs/neovim/lua/user/keymaps.lua;
  xdg.configFile."nvim/lua/user/nvim-tree.lua".source = programs/neovim/lua/user/nvim-tree.lua;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  # For VIM
  home.file.".vimrc".source = ./vimrc;
  home.file.".yabairc".source = ./yabairc;
  home.file.".skhdrc".source = ./skhdrc;

  home.packages = [
    pkgs.any-nix-shell
    pkgs.direnv
    pkgs.luajit
    pkgs.nixfmt
    pkgs.ripgrep
    pkgs.ripgrep-all
    pkgs.rnix-lsp
    pkgs.rustup
    pkgs.tree-sitter
    pkgs.stylua
    pkgs.sumneko-lua-language-server
    pkgs.rust-analyzer
  ];
}
