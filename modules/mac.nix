{ config, pkgs, lib, self, ... }: {

  nix = {
    package = pkgs.nix;
    extraOptions = ''
      system = aarch64-darwin # M1 gang
      extra-platforms = aarch64-darwin x86_64-darwin # But we use rosetta too
      experimental-features = nix-command flakes
      build-users-group = nixbld
    '' + lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";
  };

  programs.fish.enable = true;
  environment.shells = with pkgs; [ fish ];
  users.users.bradford = {
    home = "/Users/bradford";
    shell = pkgs.fish;
  };

  system.activationScripts.postActivation.text = ''
    # Set the default shell as fish for the user. MacOS doesn't do this like nixOS does
    sudo chsh -s ${lib.getBin pkgs.fish}/bin/fish bradford
  '';

  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    package = pkgs.yabai;
    config = {
      # layout
      layout = "bsp";
      auto_balance = "on";
      split_ratio = "0.50";
      window_placement = "second_child";
      # Gaps
      window_gap = 12;
      top_padding = 12;
      bottom_padding = 12;
      left_padding = 12;
      right_padding = 12;
      # shadows and borders
      window_shadow = "on";
      window_border = "off";
      window_border_width = 3;
      window_opacity = "on";
      window_opacity_duration = "0.1";
      active_window_opacity = "1.0";
      normal_window_opacity = "1.0";
      # mouse
      mouse_modifier = "cmd";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      mouse_drop_action = "swap";
    };
    extraConfig = ''
      # rules
      yabai -m rule --add app=emacs-29.0.50 manage=on
      yabai -m rule --add app='Firefox Nightly' manage=on
      yabai -m rule --add app='System Preferences' manage=off
      yabai -m rule --add app='Activity Monitor' manage=off
    '';
  };

  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = ''
      # open terminal
      cmd - return : alacritty
      # open emacs
      cmd - e : emacs
      cmd + lalt -e : emacsclient --eval "(emacs-everywhere)"
      cmd + shift -e : emacsclient --eval "(emacs-everywhere)"
      # focus window
      lalt - h : yabai -m window --focus west
      lalt - j : yabai -m window --focus south
      lalt - k : yabai -m window --focus north
      lalt - l : yabai -m window --focus east
      # swap managed window
      shift + lalt - h : yabai -m window --swap west
      shift + lalt - l : yabai -m window --swap east
      shift + lalt - j : yabai -m window --swap south
      shift + lalt - k : yabai -m window --swap north
      # focus spaces
      alt - x : yabai -m space --focus recent
      alt - 1 : yabai -m space --focus 1
      alt - 2 : yabai -m space --focus 2
      alt - 3 : yabai -m space --focus 3
      alt - 4 : yabai -m space --focus 4
      alt - 5 : yabai -m space --focus 5
      alt - 6 : yabai -m space --focus 6
      alt - 7 : yabai -m space --focus 7
      alt - 8 : yabai -m space --focus 8
      # focus on next/prev space
      alt + ctrl - q : yabai -m space --focus prev
      alt + ctrl - e : yabai -m space --focus next
      # send window to desktop
      shift + alt - x : yabai -m window --space recent
      shift + alt - 1 : yabai -m window --space 1
      shift + alt - 2 : yabai -m window --space 2
      shift + alt - 3 : yabai -m window --space 3
      shift + alt - 4 : yabai -m window --space 4
      shift + alt - 5 : yabai -m window --space 5
      shift + alt - 6 : yabai -m window --space 6
      shift + alt - 7 : yabai -m window --space 7
      shift + alt - 8 : yabai -m window --space 8
      # float / unfloat window and center on screen
      lalt - t : yabai -m window --toggle float;\
                 yabai -m window --grid 4:4:1:1:2:2
      # toggle window zoom
      lalt - d : yabai -m window --toggle zoom-parent
    '';
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs;
      [
        ibm-plex
        #self.packages.${pkgs.system}.pragmata-pro
      ];
  };
  # Remap caps lock to escape
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  # Autohide dock
  system.defaults = {
    dock = {
      autohide = true;
      showhidden = true;
      mru-spaces = false;
      orientation = "left";
    };
    NSGlobalDomain = {
      AppleFontSmoothing = 1;
      InitialKeyRepeat = 10;
      KeyRepeat = 1;
    };
  };
}
