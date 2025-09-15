-- cmp/init.lua
local M = {}

function M.setup()
  local cmp = require('cmp')
  local lspkind_ok, lspkind = pcall(require, 'lspkind')
  local snip = require('sree.cmp.snippets')
  local sources = require('sree.cmp.sources').list()

  cmp.setup({
    completion = { completeopt = 'menu,menuone,noinsert' },
    snippet = { expand = snip.expand },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif snip.luasnip.expand_or_jumpable() then
          snip.luasnip.expand_or_jump()
        elseif snip.has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif snip.luasnip.jumpable(-1) then
          snip.luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
    formatting = {
      format = lspkind_ok and lspkind.cmp_format({ mode = 'symbol_text', maxwidth = 50, ellipsis_char = '…' }) or nil,
    },
    sources = sources,
    experimental = { ghost_text = true },
  })
end

return M
