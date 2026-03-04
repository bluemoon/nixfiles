{ ... }: {
  programs.tmux = {
    enable = true;
    # Keep custom prefix behavior (Ctrl-o)
    shortcut = "o";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 100000;
    keyMode = "vi";
    terminal = "tmux-256color";
    extraConfig = ''
      # Better UX defaults
      set -g mouse on
      set -g set-clipboard on
      set -g renumber-windows on
      set -g focus-events on
      set -g allow-passthrough on
      set -as terminal-features ",xterm-256color:RGB,screen-256color:RGB,tmux-256color:RGB"

      # Make wheel scrolling reliably enter copy mode and scroll history
      bind -n WheelUpPane if-shell -F '#{pane_in_mode}' 'send-keys -M' 'copy-mode -e; send-keys -M'
      bind -n WheelDownPane select-pane -t= \; send-keys -M

      # Vim-like copy mode with macOS clipboard integration
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
      bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy"
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"

      # Intuitive split bindings
      unbind '"'
      unbind %
      bind | split-window -h
      bind - split-window -v

      # Fast pane navigation after prefix
      bind -r h select-pane -L
      bind -r j select-pane -D
      bind -r k select-pane -U
      bind -r l select-pane -R

      # Quick status line toggle
      bind s set-option -g status off
      bind C-s set-option -g status on
    '';
  };
}
