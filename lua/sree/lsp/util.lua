-- lsp/util.lua
local M = {}

function M.json_schemas()
  local ok, schemastore = pcall(require, 'schemastore')
  if ok then return schemastore.json.schemas() end
  return {}
end

return M
