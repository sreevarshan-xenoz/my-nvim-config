-- core/util.lua
-- Shared utility helpers
local M = {}

function M.safe_require(mod)
  local ok, val = pcall(require, mod)
  if ok then return val end
  return nil
end

function M.command(name, rhs, opts)
  opts = opts or {}
  vim.api.nvim_create_user_command(name, rhs, opts)
end

function M.module_loaded(name)
  return package.loaded[name] ~= nil
end

return M
