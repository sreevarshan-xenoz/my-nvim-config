-- plugins/init.lua
-- Central plugin specification for lazy.nvim (Phase 0 minimal)

local plugins = {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = {
      options = { theme = 'auto', section_separators = '', component_separators = '' },
    },
  },
}

return plugins
