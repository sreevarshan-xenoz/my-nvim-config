-- lsp/servers/gopls.lua
return function(opts)
  opts.settings = {
    gopls = {
      analyses = { unusedparams = true, shadow = true },
      staticcheck = true,
    },
  }
end
