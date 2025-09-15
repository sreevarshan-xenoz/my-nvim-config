-- lsp/servers/yamlls.lua
return function(opts)
  opts.settings = { yaml = { keyOrdering = false } }
end
