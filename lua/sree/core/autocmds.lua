-- core/autocmds.lua
local api = vim.api

local augroup = function(name)
  return api.nvim_create_augroup('Sree_' .. name, { clear = true })
end

-- Highlight on yank (quality-of-life)
api.nvim_create_autocmd('TextYankPost', {
  group = augroup('Yank'),
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 120 })
  end,
})

-- Restore cursor position
api.nvim_create_autocmd('BufReadPost', {
  group = augroup('LastPos'),
  callback = function(ev)
    local mark = api.nvim_buf_get_mark(ev.buf, '"')
    local lcount = api.nvim_buf_line_count(ev.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Quick close for certain buffers (will expand)
api.nvim_create_autocmd('FileType', {
  group = augroup('QuickClose'),
  pattern = { 'help', 'qf', 'lspinfo' },
  callback = function()
    vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = true, silent = true })
  end,
})

-- Colorscheme reapply hook (wallbash translation placeholder)
api.nvim_create_autocmd('ColorScheme', {
  group = augroup('ThemeReapply'),
  callback = function()
    if package.loaded['sree.ui.theme'] then
      local theme = require('sree.ui.theme')
      if theme.refresh then theme.refresh() end
    end
  end,
})

return true
