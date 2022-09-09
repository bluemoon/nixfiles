return function()
  local saga = safe_require 'lspsaga'
  if not saga then
    return
  end

  saga.init_lsp_saga()

  -- Lsp finder find the symbol definition implement reference
  -- when you use action in finder like open vsplit then you can
  -- use <C-t> to jump back
  vim.keymap.set('n', 'gh', '<cmd>Lspsaga lsp_finder<CR>', { silent = true })
  -- Code action
  vim.keymap.set({ 'n', 'v' }, '<leader>ca', '<cmd>Lspsaga code_action<CR>', { silent = true })
  -- Rename
  vim.keymap.set('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', { silent = true })
  -- Peek Definition
  vim.keymap.set('n', 'gd', '<cmd>Lspsaga peek_definition<CR>', { silent = true })
  -- Show line diagnostics
  vim.keymap.set('n', '<leader>cd', '<cmd>Lspsaga show_line_diagnostics<CR>', { silent = true })
  -- Show cursor diagnostic
  vim.keymap.set('n', '<leader>cd', '<cmd>Lspsaga show_cursor_diagnostics<CR>', { silent = true })
end
