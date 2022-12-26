return function()
  local ts = safe_require 'nvim-treesitter.configs'
  local comment = safe_require 'Comment'

  if not ts or not comment then
    return
  end

  ts.setup {
    context_commentstring = {
      enable = true,
      enable_autocmd = true,
    },
  }

  comment.setup {
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
  }
end
