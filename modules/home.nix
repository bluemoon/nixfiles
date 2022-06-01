{ config, pkgs, home-manager, ... }:

{
  # Let Home Manager install and manage itself.
  # programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  # home.username = "bradford";
  # home.homeDirectory = "/Users/bradford";
  home.sessionVariables = { EDITOR = "nvim"; };
  #
  programs.direnv = {
    enable = true;
    # enableFishIntegration = true;
    nix-direnv.enable = true;
  };


  programs.bat = { enable = true; };

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

  # ZOxide
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  # Enable ZSH
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    initExtra = ''
      export PATH=/Users/bradfordtoney/.cargo/bin:$HOME/go/bin:/usr/local/bin:/Users/bradfordtoney/.nix-profile/bin/:/home/bradford/.local/bin/:$PATH
      export PATH="$(yarn global bin):$PATH"
      eval "$(zoxide init zsh)"
    '';
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      # plugins = [ "command-not-found" "git" "history" "sudo" "fzf" "dotenv" ];
    };
    shellAliases = {
      k = "kubectl";
      vi = "nvim";
      vim = "nvim";
    };
  };
  # Git config
  programs.git = {
    enable = true;
    userName = "Bradford Toney";
    userEmail = "bradford.toney@gmail.com";
    aliases = { st = "status"; };

    extraConfig = {
      core = { editor = "nvim"; };
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
    };
  };
  xdg.configFile."nvim/init.lua".source = ../programs/neovim/init.lua;
  xdg.configFile."nvim/lua/user".source = ../programs/neovim/lua/user;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  # home.file.".yabairc".source = ../programs/yabai/yabairc;
  # home.file.".skhdrc".source = ..programs/skhd/skhdrc;

  home.packages = [
    pkgs.any-nix-shell
    # pkgs.direnv
    pkgs.fd
    pkgs.htop
    pkgs.luajit
    pkgs.nodejs
    pkgs.nixfmt
    pkgs.nix-prefetch
    pkgs.ripgrep
    pkgs.ripgrep-all
    pkgs.rnix-lsp
    pkgs.rustup
    pkgs.tmux
    pkgs.tree-sitter
    pkgs.stylua
    pkgs.sumneko-lua-language-server
    pkgs.rust-analyzer
    pkgs.zoxide
  ];

  imports = [ home-manager/fish.nix home-manager/tmux.nix home-manager/alacritty.nix ];
}
