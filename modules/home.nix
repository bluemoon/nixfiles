{
  config,
  pkgs,
  home-manager,
  inputs,
  ...
}:

{
  # Let Home Manager install and manage itself.
  #programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  # home.username = "bradford";
  # home.homeDirectory = "/Users/bradford";
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  #
  programs.direnv = {
    enable = true;
    # enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  programs.bat = {
    enable = true;
  };

  # Better ls
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
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

  # Git config
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Bradford Toney";
        email = "bradford.toney@gmail.com";
        signingkey = "9159E6B4C25B8F6B";
      };
      alias = {
        st = "status";
      };
      core = {
        editor = "nvim";
      };
      # TODO: Breaks Cargo?
      # url."ssh://git@github.com/".insteadOf = "https://github.com/";
      pull.rebase = true;
      push.autoSetupRemote = true;
      commit.gpgsign = true;
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

  # home.file.".yabairc".source = ../programs/yabai/yabairc;
  # home.file.".skhdrc".source = ..programs/skhd/skhdrc;

  home.packages = [
    pkgs.any-nix-shell
    # pkgs.direnv
    pkgs.ast-grep
    pkgs.fd
    pkgs.gnupg
    pkgs.htop
    pkgs.jq
    pkgs.luajit
    pkgs.nodejs
    pkgs.nixfmt-classic
    pkgs.nix-prefetch
    pkgs.protobuf
    pkgs.ripgrep
    pkgs.ripgrep-all
    pkgs.nil
    pkgs.rustup
    pkgs.tmux
    pkgs.tree-sitter
    pkgs.tree-sitter-grammars.tree-sitter-nix
    pkgs.stylua
    pkgs.sumneko-lua-language-server
    pkgs.zoxide
    pkgs.yarn
    pkgs.ruby
    pkgs.claude-code
    pkgs.pnpm
    pkgs.kamal
    pkgs._1password-cli
    pkgs._1password-gui
    pkgs.zig
    pkgs.caddy
    pkgs.cmake
    pkgs.pyrefly
    pkgs.jujutsu
    pkgs.codex
    pkgs.postgresql_16
    pkgs.granted
    (pkgs.awscli2.overrideAttrs (old: {
      doCheck = false;
      doInstallCheck = false;
    }))
    inputs.nixvim-config.packages.${pkgs.system}.default
  ];

  imports = [
    ./home-manager/fish.nix
    ./home-manager/tmux.nix
  ];
}
