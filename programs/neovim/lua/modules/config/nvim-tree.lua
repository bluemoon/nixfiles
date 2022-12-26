return function()
  local nvim_tree = safe_require 'nvim-tree'
  if not nvim_tree then
    return
  end

  nvim_tree.setup {
    cursorline = {
      enable = true,
    },
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = true,
    },
  }

  nvim_tree.toggle(true)
end
