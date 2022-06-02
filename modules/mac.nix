{ config, pkgs, lib, ... }: {

  nix = {
    package = pkgs.nix;
    extraOptions = ''
      system = aarch64-darwin # M1 gang
      extra-platforms = aarch64-darwin x86_64-darwin # But we use rosetta too
      experimental-features = nix-command flakes
      build-users-group = nixbld
    '';
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
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      ibm-plex
      pragmata-pro
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
  };

}
