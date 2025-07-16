{ config, pkgs, lib, inputs, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    extraPackages = with pkgs; [
      # Language servers
      rnix-lsp
      sumneko-lua-language-server
      rust-analyzer
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.yaml-language-server
      nodePackages.pyright
      
      # Formatters
      stylua
      nixfmt
      nodePackages.prettier
      black
      rustfmt
      
      # Tools
      tree-sitter
      ripgrep
      fd
      fzf
    ];

    extraLuaConfig = ''
      -- Ensure packer is installed before loading config
      local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
      if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
        vim.cmd 'packadd packer.nvim'
      end

      ${builtins.readFile ../../programs/neovim/init.lua}
    '';
  };

  # Link the lua directory
  xdg.configFile."nvim/lua".source = ../../programs/neovim/lua;
}