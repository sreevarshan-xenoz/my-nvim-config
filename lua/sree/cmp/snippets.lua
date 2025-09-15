-- cmp/snippets.lua
local M = {}

local luasnip = require('luasnip')

-- Load friendly-snippets lazily
require('luasnip.loaders.from_vscode').lazy_load()

-- Example custom snippets (extend later)
luasnip.add_snippets('lua', {
  luasnip.snippet('req', { luasnip.text_node("local "), luasnip.insert_node(1, 'mod'), luasnip.text_node(" = require('"), luasnip.insert_node(2, 'module'), luasnip.text_node("')") }),
})

function M.expand(args)
  luasnip.lsp_expand(args.body)
end

function M.has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

M.luasnip = luasnip

return M
