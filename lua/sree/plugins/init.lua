-- plugins/init.lua
-- Central plugin specification for lazy.nvim (Phase 0 minimal -> enriched -> Phase 1 start)

local plugins = {
  -- Which-key (already present)
  { 'folke/which-key.nvim', event = 'VeryLazy', config = function()
      local wk = require('which-key')
      wk.setup({})
      local ok_ns, ns = pcall(require, 'sree.core.whichkey')
      if ok_ns then ns.register(wk) end
    end },

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

  -- Treesitter core
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn',
          node_incremental = 'grn',
          scope_incremental = 'grc',
          node_decremental = 'grm',
        },
      },
      ensure_installed = {
        'lua',
        'vim',
        'vimdoc',
        'bash',
        'json',
        'markdown',
        'markdown_inline',
        'python',
        'go',
        'rust',
        'yaml',
        'toml',
        'tsx',
        'typescript',
        'javascript',
        'query',
        'regex',
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  -- Treesitter textobjects (separate so it can lazy load after core)
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = 'BufReadPost',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']m'] = '@function.outer',
            [']c'] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[c'] = '@class.outer',
          },
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  -- Telescope core + fzf optional
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' }, cmd = 'Telescope', keys = {
      { '<leader>ff', function() require('telescope.builtin').find_files() end, desc = 'Find Files' },
      { '<leader>fg', function() require('telescope.builtin').live_grep() end, desc = 'Live Grep' },
      { '<leader>fb', function() require('telescope.builtin').buffers() end, desc = 'Buffers' },
      { '<leader>fh', function() require('telescope.builtin').help_tags() end, desc = 'Help Tags' },
    },
    opts = { defaults = { prompt_prefix = '  ', selection_caret = ' ', sorting_strategy = 'ascending', layout_config = { horizontal = { prompt_position = 'top' } } } },
    config = function(_, opts)
      local tel = require('telescope')
      tel.setup(opts)
      pcall(tel.load_extension, 'fzf')
    end },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = function() return vim.fn.executable('make') == 1 end },
}

return plugins
