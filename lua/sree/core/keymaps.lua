-- core/keymaps.lua
local map = vim.keymap.set
local silent = { silent = true }

-- Basic remaps derived from legacy & enhancements
map('n', '<leader>w', ':w<CR>', silent)
map('n', ';', ':', { silent = false }) -- optional, can be flagged later
map('v', ';', ':', { silent = false })

-- Window navigation improvements
map('n', '<C-h>', '<C-w>h', silent)
map('n', '<C-j>', '<C-w>j', silent)
map('n', '<C-k>', '<C-w>k', silent)
map('n', '<C-l>', '<C-w>l', silent)

-- Resize splits
map('n', '<A-Left>', '2<cmd>vertical resize -2<CR>', silent)
map('n', '<A-Right>', '2<cmd>vertical resize +2<CR>', silent)
map('n', '<A-Up>', '2<cmd>resize -2<CR>', silent)
map('n', '<A-Down>', '2<cmd>resize +2<CR>', silent)

-- Clear highlights
map('n', '<leader>h', ':nohlsearch<CR>', silent)

-- Manual format trigger (LSP/none-ls) fallback
map('n', '<leader>cf', function()
  if vim.lsp.buf.format then
    vim.lsp.buf.format({ async = true })
  else
    vim.cmd('Format')
  end
end, { desc = 'Format Buffer', silent = true })

-- Placeholder for future AI / Sys / Ops keymaps
-- map('n', '<leader>ai', function() require('sree.ai.chat').toggle() end, silent)
-- map('v', '<leader>ar', function() require('sree.ai.rewrite').visual_rewrite() end, silent)
-- map('n', '<leader>ss', ':Sys stats<CR>', silent)

return true
