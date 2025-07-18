{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      kanagawa-nvim  # Add other plugins here as needed
    ];

    extraPackages = with pkgs; [
      # Language servers
      nil
      sumneko-lua-language-server
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.yaml-language-server
      pyright
      
      # Formatters
      stylua
      nixfmt-classic
      nodePackages.prettier
      python311Packages.black
      rustfmt
      
      # Tools
      tree-sitter
      ripgrep
      fd
      fzf
    ];

    extraLuaConfig = builtins.readFile ../../programs/neovim/init.lua;
  };

  # Link the lua directory
  xdg.configFile."nvim/lua".source = ../../programs/neovim/lua;
}