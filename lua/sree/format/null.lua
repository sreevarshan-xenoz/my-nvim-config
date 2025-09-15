-- format/null.lua
local M = {}

function M.setup()
  local null_ok, null_ls = pcall(require, 'null-ls')
  if not null_ok then return end

  local fmt = null_ls.builtins.formatting
  local diag = null_ls.builtins.diagnostics

  local sources = {
    fmt.stylua,
    fmt.prettierd,
    fmt.shfmt,
    fmt.black,
    fmt.gofumpt,
    fmt.rustfmt,
    diag.eslint_d,
  }

  null_ls.setup({
    border = 'rounded',
    sources = sources,
    on_attach = function(client, bufnr)
      -- Manual only formatting baseline
      if client.supports_method('textDocument/formatting') then
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end, { desc = 'Buffer Format (null-ls/LSP)' })
      end
    end,
  })
end

return M
