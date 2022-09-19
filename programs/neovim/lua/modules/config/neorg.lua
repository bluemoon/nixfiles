return function()
  local neorg = safe_require 'neorg'
  if not neorg then
    return
  end

  neorg.setup {
    ['core.defaults'] = {},
    ['core.norg.dirman'] = {
      config = {
        workspaces = {
          work = '~/notes/work',
          home = '~/notes/home',
        },
      },
    },
    --['core.norg.concealer'] = {
    --  config = {
    --    icon_preset = 'varied',
    --    markup_preset = 'safe',
    --  },
    --},
  }
end
