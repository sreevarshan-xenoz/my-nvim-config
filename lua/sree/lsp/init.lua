-- lsp/init.lua
local M = {}
local handlers = require('sree.lsp.handlers')

local servers = {
  lua_ls = {},
  bashls = {},
  pyright = {},
  tsserver = {},
  gopls = {},
  rust_analyzer = {},
  jsonls = {},
  yamlls = {},
  marksman = {},
}

local function enhance(server, opts)
  local ok_mod, mod = pcall(require, 'sree.lsp.servers.' .. server)
  if ok_mod and type(mod) == 'function' then
    mod(opts)
  end
  return opts
end

function M.setup()
  local lspconfig = require('lspconfig')
  for name, conf in pairs(servers) do
    local opts = vim.tbl_deep_extend('force', {
      on_attach = handlers.on_attach,
      capabilities = handlers.capabilities,
      flags = { debounce_text_changes = 150 },
    }, conf)
    opts = enhance(name, opts)
    lspconfig[name].setup(opts)
  end
end

return M
