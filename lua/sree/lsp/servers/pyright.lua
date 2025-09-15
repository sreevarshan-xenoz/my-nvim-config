-- lsp/servers/pyright.lua
return function(opts)
  opts.settings = {
    python = {
      analysis = {
        typeCheckingMode = 'basic',
        autoImportCompletions = true,
      },
    },
  }
end
