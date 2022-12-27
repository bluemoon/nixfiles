-- require "user.plugins"
-- require "user.autocmd"
-- require "user.cmp"
-- require "user.colorscheme"
-- require "user.comment"
-- require "user.gitsigns"
-- require "user.lsp"
-- require "user.nvim-tree"
-- require "user.options"
-- require "user.project"
-- require "user.treesitter"
-- require "user.toggleterm"
-- require "user.keymaps"

require 'core.utils'
require 'core.options'
require 'modules'
require 'core.keymaps'

vim.g.catppuccin_flavour = 'macchiato'
vim.cmd 'colorscheme kanagawa'
