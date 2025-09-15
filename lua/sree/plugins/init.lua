-- plugins/init.lua
-- Central plugin specification for lazy.nvim (Phase 0 minimal -> enriched)

local plugins = {
  -- Which-key (already present)
  { 'folke/which-key.nvim', event = 'VeryLazy', opts = {} },

  -- Statusline
  { 'nvim-lualine/lualine.nvim', event = 'VeryLazy', opts = { options = { theme = 'auto', section_separators = '', component_separators = '' } } },

  -- File explorer (oil) minimal friction
  {
    'stevearc/oil.nvim',
    cmd = { 'Oil' },
    keys = { { '<leader>e', function() require('oil').toggle_float() end, desc = 'Explorer (oil)' } },
    opts = {
      view_options = { show_hidden = true },
      float = { padding = 2, max_width = 90, max_height = 30, border = 'rounded' },
    },
  },

  -- Icons (used by multiple layers)
  { 'nvim-tree/nvim-web-devicons', lazy = true },

  -- Git signs
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = { add = { text = '+' }, change = { text = '~' }, delete = { text = '_' }, topdelete = { text = '‾' }, changedelete = { text = '~' } },
      attach_to_untracked = false,
    },
  },

  -- Notifications
  {
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    config = function()
      local notify = require('notify')
      notify.setup({ stages = 'fade_in_slide_out', timeout = 2500, fps = 60, render = 'compact' })
      vim.notify = notify
    end,
  },

  -- Colorscheme (tokyonight) + apply early after load
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = { style = 'night', transparent = true, styles = { sidebars = 'transparent', floats = 'transparent' } },
    config = function(_, opts)
      require('tokyonight').setup(opts)
      vim.cmd.colorscheme('tokyonight')
      -- Overlay custom theme adjustments
      local ok_theme, theme = pcall(require, 'sree.ui.theme')
      if ok_theme and theme.apply then theme.apply() end
    end,
  },
}

return plugins
