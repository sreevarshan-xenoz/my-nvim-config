-- lsp/servers/rust_analyzer.lua
return function(opts)
  opts.settings = {
    ['rust-analyzer'] = {
      cargo = { allFeatures = true },
      checkOnSave = { command = 'clippy' },
    },
  }
end
