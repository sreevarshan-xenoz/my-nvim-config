-- lsp/servers/jsonls.lua
return function(opts)
  opts.settings = { json = { schemas = require('sree.lsp.util').json_schemas(), validate = { enable = true } } }
end
