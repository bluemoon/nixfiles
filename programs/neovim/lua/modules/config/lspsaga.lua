return function()
  local saga = safe_require 'lspsaga'
  if not saga then
    return
  end

  saga.init_lsp_saga()
end
