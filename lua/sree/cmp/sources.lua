-- cmp/sources.lua
local M = {}

function M.list()
  local sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
    { name = 'luasnip' },
    { name = 'nvim_lua' },
  }
  return sources
end

return M
