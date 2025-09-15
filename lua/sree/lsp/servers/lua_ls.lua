-- lsp/servers/lua_ls.lua
return function(opts)
  opts.settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      hint = { enable = true },
    },
  }
end
