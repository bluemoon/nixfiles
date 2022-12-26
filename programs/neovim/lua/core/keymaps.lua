local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap('n', '<C-h>', '<C-w>h', opts)
keymap('n', '<C-j>', '<C-w>j', opts)
keymap('n', '<C-k>', '<C-w>k', opts)
keymap('n', '<C-l>', '<C-w>l', opts)

vim.api.nvim_set_keymap(
  'n',
  '<Leader>ff',
  [[<Cmd>lua require('telescope.builtin').find_files()<CR>]],
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  '<Leader>fg',
  [[<Cmd>lua require('telescope.builtin').live_grep()<CR>]],
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  '<Leader>fb',
  [[<Cmd>lua require('telescope.builtin').buffers()<CR>]],
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  '<Leader>fh',
  [[<Cmd>lua require('telescope.builtin').help_tags()<CR>]],
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  '',
  'f',
  "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>"
  ,
  {}
)
vim.api.nvim_set_keymap(
  '',
  'F',
  "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>"
  ,
  {}
)
vim.api.nvim_set_keymap(
  '',
  't',
  "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>"
  ,
  {}
)
vim.api.nvim_set_keymap(
  '',
  'T',
  "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>"
  ,
  {}
)
-- Code action
vim.keymap.set({ 'n', 'v' }, '<leader>ca', '<cmd>Lspsaga code_action<CR>', { silent = true })
-- Rename
vim.keymap.set('n', 'gr', '<cmd>Lspsaga rename<CR>', { silent = true })
