return function()
  local comment = safe_require 'Comment'

  if not comment then
    return
  end

  comment.setup {}
end
