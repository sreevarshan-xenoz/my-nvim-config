-- lsp/handlers.lua
local M = {}

local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end

vim.diagnostic.config({
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  virtual_text = { prefix = '●', spacing = 2 },
  underline = true,
  update_in_insert = false,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if ok_cmp then capabilities = cmp_lsp.default_capabilities(capabilities) end

local function lsp_keymaps(buf)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
  end
  map('n', 'gd', vim.lsp.buf.definition, 'Goto Definition')
  map('n', 'gr', vim.lsp.buf.references, 'References')
  map('n', 'gI', vim.lsp.buf.implementation, 'Implementation')
  map('n', 'K', vim.lsp.buf.hover, 'Hover')
  map('n', '<leader>cr', vim.lsp.buf.rename, 'Rename')
  map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
  map('n', '<leader>cd', vim.diagnostic.open_float, 'Line Diagnostics')
  map('n', '[d', vim.diagnostic.goto_prev, 'Prev Diagnostic')
  map('n', ']d', vim.diagnostic.goto_next, 'Next Diagnostic')
  map('n', '<leader>cf', function() vim.lsp.buf.format({ async = true }) end, 'Format Buffer')
end

function M.on_attach(client, bufnr)
  lsp_keymaps(bufnr)
end

M.capabilities = capabilities

return M
