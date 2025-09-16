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

-- Test mappings
map('n', '<leader>tt', function() require('sree.test').run_current() end, { desc = 'Test: nearest', silent = true })
map('n', '<leader>tf', function() require('sree.test').run_file() end, { desc = 'Test: file', silent = true })
map('n', '<leader>td', function() require('sree.test').run_nearest_debug() end, { desc = 'Test: debug nearest', silent = true })
map('n', '<leader>to', function() require('sree.test').open_output() end, { desc = 'Test: output', silent = true })
map('n', '<leader>ts', function() require('sree.test').toggle_summary() end, { desc = 'Test: summary', silent = true })

-- Placeholder for future AI / Sys / Ops keymaps
map('n', '<leader>ai', function() require('sree.ai.chat').toggle() end, silent)
map('v', '<leader>ar', function() require('sree.ai.rewrite').visual_rewrite() end, silent)
map('n', '<leader>ss', function() vim.cmd('Sys stats') end, { desc = 'Sys: stats', silent = true })
map('n', '<leader>so', function() vim.cmd('OpsToggle') end, { desc = 'Sys: dashboard toggle', silent = true })

-- Embeddings (Phase 6) mappings under <leader>se*
map('n', '<leader>sei', function() vim.cmd('EmbedIndex') end, { desc = 'Embeddings: index project', silent = true })
map('n', '<leader>seq', function()
  vim.ui.input({ prompt = 'Embedding query: ' }, function(input)
    if input and #input > 0 then vim.cmd('EmbedQuery ' .. input) end
  end)
end, { desc = 'Embeddings: query', silent = true })
map('n', '<leader>ses', function() vim.cmd('EmbedStatus') end, { desc = 'Embeddings: status', silent = true })

return true
