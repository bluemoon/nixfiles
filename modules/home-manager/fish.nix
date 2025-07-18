{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    package = pkgs.fish;
    loginShellInit = ''
      set -xg TERM xterm-256color

      fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /run/current-system/sw/bin /nix/var/nix/profiles/default/bin 

      # User paths
      fish_add_path -g $HOME/bin
      fish_add_path -g $HOME/.local/bin

      # Development tools
      fish_add_path -g $HOME/.cargo/bin

      # Yarn global bin - check if yarn exists first
      if command -q yarn
        set -l yarn_global_bin (yarn global bin 2>/dev/null)
        if test -n "$yarn_global_bin"
          fish_add_path -g $yarn_global_bin
        end
      end
    '';

    interactiveShellInit = ''
      any-nix-shell fish --info-right | source
      set -xg NIX_PATH $HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels
      set -xg NIXPKGS_ALLOW_UNFREE 1
      eval (zoxide init fish)
      eval (direnv hook fish)

      function rebuild-mbp
        pushd ~/.config/nixpkgs
        eval nix build ~/.config/nixpkgs#darwinConfigurations.bradford-mbp.system
        eval ./result/sw/bin/darwin-rebuild switch --flake .#bradford-mbp
        popd
      end

      status --is-interactive; and rbenv init - fish | source

      # Tide configuration - minimal but informative
      if status is-interactive
        # Run tide configure on first setup if needed
        if not set -q tide_prompt_add_newline_before
          tide configure --auto --style=lean --prompt_colors='True color' --classic_prompt_color='Dark' --show_time='No' --lean_prompt_height='Two lines' --prompt_connection='Disconnected' --prompt_spacing='Sparse' --icons='Few icons' --transient='No'
        end
        
        # Left prompt: path, git info, and prompt character on new line
        set -g tide_left_prompt_items pwd git newline character
        
        # Right prompt: just status and long-running commands
        set -g tide_right_prompt_items status cmd_duration
        
        # Clean up icons for minimal look
        set -g tide_pwd_icon ""
        set -g tide_pwd_icon_home "~"
        set -g tide_git_icon " "
        
        # Simple prompt character
        set -g tide_character_icon "❯"
        
        # Only show cmd_duration for commands over 3 seconds
        set -g tide_cmd_duration_threshold 3000
        set -g tide_cmd_duration_icon ""
        
        # Show context only when in SSH or as root
        set -g tide_context_always_display false
        
        # Fix for git truncation
        set -g tide_git_truncation_length 24
        set -g tide_git_truncation_strategy ""
      end

      # Git helper functions
      function git_current_branch
        git branch --show-current 2> /dev/null
      end

      function gdnolock
        git diff $argv --color | sed 's/index [0-9a-f]\{7\}\.\.[0-9a-f]\{7\}/index .../g'
      end

      function grename
        if test (count $argv) -ne 2
          echo "Usage: grename old_branch new_branch"
          return 1
        end
        git branch -m $argv[1] $argv[2]
        if git push origin :$argv[1]
          git push --set-upstream origin $argv[2]
        end
      end

      # Kill process on specified port
      function killport
        if test (count $argv) -eq 0
          echo "Usage: killport <port>"
          return 1
        end
        set -l port $argv[1]
        set -l pid (lsof -ti:$port)
        if test -n "$pid"
          kill -9 $pid
          echo "Killed process $pid on port $port"
        else
          echo "No process found on port $port"
        end
      end

      # FZF configuration
      if type -q fzf
        # Use fd for better file finding if available
        if type -q fd
          set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
          set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
        end
        
        # Better preview with bat if available
        if type -q bat
          set -gx FZF_CTRL_T_OPTS "--preview 'bat --style=numbers --color=always --line-range :500 {}'"
        end
        
        # Ctrl+R for history search
        bind \cr 'commandline -f history-search-backward'
        
        # Custom fzf history widget
        function fzf_history_widget
          set -l cmd (history | fzf --tiebreak=index --query=(commandline) | string split -m1 ' ')[2]
          if test -n "$cmd"
            commandline -r $cmd
          end
          commandline -f repaint
        end
        bind \cr fzf_history_widget
      end
    '';

    shellAliases = {
      cat = "bat";
      vim = "nvim";
      g = "git";
      ga = "git add";
      gaa = "git add --all";
      gc = "git commit -v";
    };

    shellAbbrs = {
      # Git shortcuts
      gapa = "git add --patch";
      gau = "git add --update";
      gav = "git add --verbose";
      gap = "git apply";
      gapt = "git apply --3way";

      gb = "git branch";
      gba = "git branch -a";
      gbd = "git branch -d";
      gbda = "git for-each-ref --format '%(refname:short)' refs/heads | xargs git branch -d";
      gbD = "git branch -D";
      gbl = "git blame -b -w";
      gbnm = "git branch --no-merged";
      gbr = "git branch --remote";
      gbs = "git bisect";
      gbsb = "git bisect bad";
      gbsg = "git bisect good";
      gbsr = "git bisect reset";
      gbss = "git bisect start";

      "gc!" = "git commit -v --amend";
      "gcn!" = "git commit -v --no-edit --amend";
      gca = "git commit -v -a";
      "gca!" = "git commit -v -a --amend";
      "gcan!" = "git commit -v -a --no-edit --amend";
      "gcans!" = "git commit -v -a -s --no-edit --amend";
      gcam = "git commit -a -m";
      gcsm = "git commit -s -m";
      gcb = "git checkout -b";
      gcf = "git config --list";
      gcl = "git clone --recurse-submodules";
      gclean = "git clean -id";
      gpristine = "git reset --hard && git clean -dffx";
      gcm = "git checkout main";
      gcd = "git checkout develop";
      gcmsg = "git commit -m";
      gco = "git checkout";
      gcount = "git shortlog -sn";
      gcp = "git cherry-pick";
      gcpa = "git cherry-pick --abort";
      gcpc = "git cherry-pick --continue";
      gcs = "git commit -S";

      gd = "git diff";
      gdca = "git diff --cached";
      gdcw = "git diff --cached --word-diff";
      gdct = "git describe --tags \$(git rev-list --tags --max-count=1)";
      gds = "git diff --staged";
      gdt = "git diff-tree --no-commit-id --name-only -r";
      gdw = "git diff --word-diff";

      gf = "git fetch";
      gfa = "git fetch --all --prune";
      gfo = "git fetch origin";

      gg = "git gui citool";
      gga = "git gui citool --amend";

      ghh = "git help";

      gignore = "git update-index --assume-unchanged";
      gignored = "git ls-files -v | grep '^[[:lower:]]'";

      gl = "git pull";
      glg = "git log --stat";
      glgp = "git log --stat -p";
      glgg = "git log --graph";
      glgga = "git log --graph --decorate --all";
      glgm = "git log --graph --max-count=10";
      glo = "git log --oneline --decorate";
      glol = "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
      glols = "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --stat";
      glod = "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'";
      glods = "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short";
      glola = "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all";
      glog = "git log --oneline --decorate --graph";
      gloga = "git log --oneline --decorate --graph --all";

      gm = "git merge";
      gmom = "git merge origin/main";
      gmt = "git mergetool --no-prompt";
      gmtvim = "git mergetool --no-prompt --tool=vimdiff";
      gmum = "git merge upstream/main";
      gma = "git merge --abort";

      gp = "git push";
      gpd = "git push --dry-run";
      gpf = "git push --force-with-lease";
      "gpf!" = "git push --force";
      gpoat = "git push origin --all && git push origin --tags";
      gpu = "git push upstream";
      gpv = "git push -v";

      gr = "git remote";
      gra = "git remote add";
      grb = "git rebase";
      grba = "git rebase --abort";
      grbc = "git rebase --continue";
      grbd = "git rebase develop";
      grbi = "git rebase -i";
      grbm = "git rebase main";
      grbs = "git rebase --skip";
      grev = "git revert";
      grh = "git reset";
      grhh = "git reset --hard";
      groh = "git reset origin/\$(git_current_branch) --hard";
      grm = "git rm";
      grmc = "git rm --cached";
      grmv = "git remote rename";
      grrm = "git remote remove";
      grs = "git restore";
      grset = "git remote set-url";
      grss = "git restore --source";
      grt = "cd \$(git rev-parse --show-toplevel || echo .)";
      gru = "git reset --";
      grup = "git remote update";
      grv = "git remote -v";

      gsb = "git status -sb";
      gsd = "git svn dcommit";
      gsh = "git show";
      gsi = "git submodule init";
      gsps = "git show --pretty=short --show-signature";
      gsr = "git svn rebase";
      gss = "git status -s";
      gst = "git status";

      gsta = "git stash push";
      gstaa = "git stash apply";
      gstc = "git stash clear";
      gstd = "git stash drop";
      gstl = "git stash list";
      gstp = "git stash pop";
      gsts = "git stash show --text";
      gstu = "git stash --include-untracked";
      gstall = "git stash --all";
      gsu = "git submodule update";
      gsw = "git switch";
      gswc = "git switch -c";

      gts = "git tag -s";
      gtv = "git tag | sort -V";

      gunignore = "git update-index --no-assume-unchanged";
      gunwip = "git log -n 1 | grep -q -c '\\-\\-wip\\-\\-' && git reset HEAD~1";
      gup = "git pull --rebase";
      gupv = "git pull --rebase -v";
      gupa = "git pull --rebase --autostash";
      gupav = "git pull --rebase --autostash -v";
      glum = "git pull upstream main";

      gwch = "git whatchanged -p --abbrev-commit --pretty=medium";
      gwip = "git add -A; git rm \$(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m '--wip-- [skip ci]'";
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
    {
      name = "tide";
      src = pkgs.fetchFromGitHub {
        owner = "IlanCosman";
        repo = "tide";
        rev = "v6.1.1";
        sha256 = "sha256-ZyEk/WoxdX5Fr2kXRERQS1U1QHH3oVSyBQvlwYnEYyc=";
      };
    }
  ];

}
