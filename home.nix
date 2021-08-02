{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "bradfordtoney";
  home.homeDirectory = "/Users/bradfordtoney";

  # Better ls
  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  # FZF
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Enable ZSH
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    initExtra = ''
    export PATH=/Users/bradfordtoney/.cargo/bin:$HOME/go/bin:/usr/local/bin:/Users/bradfordtoney/.nix-profile/bin/:$PATH
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

  # Git config
  programs.git = {
    enable = true;
    userName = "Bradford Toney";
    userEmail = "bradford.toney@gmail.com";
    aliases = {
      st = "status";
    };
  };

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

}
