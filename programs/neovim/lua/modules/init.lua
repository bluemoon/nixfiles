local function conf(name)
  return safe_require(string.format('modules.config.%s', name))
end

local plugins = {
  -- Colorschemes
  {
    'rebelot/kanagawa.nvim',
    config = conf 'kanagawa',
  },
  { -- Treesiter
    'nvim-treesitter/nvim-treesitter',
    config = conf 'nvim-treesitter',
  },
  { -- Finder
    'nvim-telescope/telescope.nvim',
    config = conf 'telescope',
    requires = {
      'nvim-lua/plenary.nvim',
      {
        'ahmedkhalf/project.nvim',
        config = function()
          require('project_nvim').setup {}
        end,
      },
    },
  },
  { -- Illuminate
    'RRethy/vim-illuminate',
  },
  { -- Icons
    'kyazdani42/nvim-web-devicons',
    config = conf 'nvim-web-devicons',
  },
  { --Comment
    'numToStr/Comment.nvim',
    -- config = conf 'comment',
    requires = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      config = conf 'context-commentstring',
    },
  },
  { -- Lsp
    'neovim/nvim-lspconfig',
    config = conf 'lsp',
    requires = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'jose-elias-alvarez/null-ls.nvim', -- Formatter
      'ray-x/lsp_signature.nvim',
      'jose-elias-alvarez/nvim-lsp-ts-utils',
      'RRethy/vim-illuminate',
      'simrat39/rust-tools.nvim',
      {
        'glepnir/lspsaga.nvim',
        branch = 'main',
        config = conf 'lspsaga',
      },
    },
  },
  { -- Autocompletion plugin
    'hrsh7th/nvim-cmp',
    config = conf 'nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-emoji',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'onsails/lspkind-nvim', -- Enables icons on completions
      { -- Rust crates
        'saecki/crates.nvim',
        tag = 'v0.2.1',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
          require('crates').setup()
        end,
      },
      { -- Snippets
        'L3MON4D3/LuaSnip',
        requires = {
          'saadparwaiz1/cmp_luasnip',
          'rafamadriz/friendly-snippets',
        },
      },
    },
  },
  { -- Git related
    'lewis6991/gitsigns.nvim',
    config = conf 'gitsigns',
    requires = { 'nvim-lua/plenary.nvim' },
  },
  -- { -- Indent guides
  --   'lukas-reineke/indent-blankline.nvim',
  --   config = conf 'indent-blankline',
  -- },
  { -- Statusline
    'feline-nvim/feline.nvim',
    config = conf 'feline',
  },
  { -- Hop
    'phaazon/hop.nvim',
    config = conf 'hop',
  },
  { -- Highlight current line number
    'yamatsum/nvim-cursorline',
    config = conf 'nvim-cursorline',
  },
  { -- Autosave
    'Pocco81/auto-save.nvim',
    config = conf 'auto-save',
  },
  { -- Tree
    'kyazdani42/nvim-tree.lua',
    config = conf 'nvim-tree',
  },
  { --ToggleTerm
    'akinsho/toggleterm.nvim',
    tag = '*',
    config = conf 'toggleterm',
  },
  { -- Autopairs
    'windwp/nvim-autopairs',
    config = function()
      -- todo: move to file
      require('nvim-autopairs').setup {}
    end,
  },
}

local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd 'packadd packer.nvim'
end

local packer = safe_require 'packer'
if packer then
  packer.init {
    compile_path = vim.fn.stdpath 'data' .. '/site/plugin/packer_compiled.lua',
    package_root = vim.fn.stdpath 'data' .. '/site/pack',
    display = {
      open_fn = function()
        return require('packer.util').float { border = 'rounded' }
      end,
    },
  }

  return packer.startup(function(use)
    use 'wbthomason/packer.nvim'
    for _, plugin in ipairs(plugins) do
      use(plugin)
    end
  end)
end
