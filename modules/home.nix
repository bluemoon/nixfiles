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
    PNPM_HOME = "$HOME/.local/bin";
    # SSL certificates for all programs
    SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    CURL_CA_BUNDLE = "/etc/ssl/certs/ca-certificates.crt";
    GIT_SSL_CAINFO = "/etc/ssl/certs/ca-certificates.crt";
  };
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
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

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      identityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
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
    pkgs.go
    pkgs.gh
    pkgs.gnupg
    pkgs.htop
    pkgs.jq
    pkgs.just
    pkgs.luajit
    pkgs.nodejs
    pkgs.nixfmt-classic
    pkgs.nix-prefetch
    pkgs.openssl
    pkgs.protobuf
    pkgs.pkg-config
    pkgs.ripgrep
    pkgs.ripgrep-all
    pkgs.ruff
    pkgs.nil
    pkgs.rustup
    pkgs.tmux
    pkgs.tree
    pkgs.tree-sitter
    pkgs.tree-sitter-grammars.tree-sitter-nix
    pkgs.stylua
    pkgs.lua-language-server
    pkgs.zoxide
    pkgs.yarn
    pkgs.ruby
    pkgs.claude-code
    pkgs.pnpm
    pkgs.kamal
    pkgs._1password-cli
    pkgs._1password-gui
    pkgs.raycast
    pkgs.zig
    pkgs.uv
    pkgs.caddy
    pkgs.cmake
    pkgs.curl
    pkgs.colima
    pkgs.docker
    pkgs.duckdb
    pkgs.pyrefly
    # pkgs.jujutsu
    pkgs.codex
    pkgs.opencode
    pkgs.postgresql_16
    pkgs.granted
    pkgs.grpcurl
    pkgs.overmind
    pkgs.python3Packages.localstack-client
    pkgs.kcat
    pkgs.age
    pkgs.sops
    pkgs.kubectl

    # Shell enhancements
    pkgs.starship
    pkgs.pay-respects
    pkgs.tldr

    # System monitoring
    pkgs.btop
    pkgs.procs
    pkgs.duf
    pkgs.dust
    pkgs.bandwhich

    # File management
    pkgs.yazi

    # Network/HTTP
    pkgs.xh
    pkgs.doggo

    # Data processing
    pkgs.yq-go
    pkgs.miller
    pkgs.jless

    # Git/Diff
    pkgs.lazygit
    pkgs.delta
    pkgs.difftastic

    # Dev tools
    pkgs.hyperfine
    pkgs.tokei
    pkgs.watchexec

    # Containers
    pkgs.lazydocker
    pkgs.k9s
    pkgs.skopeo
    pkgs.fluxcd

    # Misc
    pkgs.glow
    pkgs.fastfetch
    pkgs.gnuplot
    (pkgs.snowflake-cli.overrideAttrs (old: {
      doCheck = false;
      doInstallCheck = false;
    }))
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
