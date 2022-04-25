{ ... }: {
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

      set -xg PATH $HOME/bin $HOME/.cargo/bin $HOME/.local/bin /opt/homebrew/bin $PATH
      set -xg PATH (yarn global bin) $PATH
    '';

    interactiveShellInit = ''
      eval (direnv hook fish)
      any-nix-shell fish --info-right | source
    '';

    shellAliases = {
      cat = "bat";
      vim = "nvim";
    };
  };

  programs.fish.plugins = [
    {
      name = "fenv";
      src = pkgs.fetchFromGitHub {
        owner = "oh-my-fish";
        repo = "plugin-foreign-env";
        rev = "b3dd471bcc885b597c3922e4de836e06415e52dd";
        sha256 = "sha256-3h03WQrBZmTXZLkQh1oVyhv6zlyYsSDS7HTHr+7WjY8=";
      };
    }
    {
      name = "git";
      src = pkgs.fetchFromGitHub {
        owner = "jhillyerd";
        repo = "plugin-git";
        rev = "2a3e35c05bdc5b9005f917d5281eb866b2e13104";
        sha256 = "sha256-tWiGIB6yHfZ+QSNJrahHxRQCIOaOlSNFby4bGIOIwic=";
      };
    }
  ];

}
