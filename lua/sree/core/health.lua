-- core/health.lua
-- :SreeHealth command summarizing core modules, flags, startup, plugins
local util = require('sree.core.util')
local flags = require('sree.flags')

local function lsp_server_count()
  local clients = vim.lsp.get_active_clients and vim.lsp.get_active_clients() or {}
  return #clients
end

local function collect()
  local loaded = vim.tbl_keys(package.loaded)
  table.sort(loaded)
  local plugins = {}
  if util.safe_require('lazy') then
    local ok, stats = pcall(require('lazy').stats)
    if ok then plugins = stats().loaded end
  end
  local ms = rawget(_G, 'SreeStartupMs')
  return {
    startup_ms = ms,
    flags = flags,
    modules_loaded = #loaded,
    plugin_count = plugins,
    background = vim.o.background,
    colorscheme = vim.g.colors_name,
    lsp_active = lsp_server_count(),
  }
end

util.command('SreeHealth', function()
  local data = collect()
  vim.notify(('[SreeHealth] startup=%.1fms plugins=%s lsp=%d bg=%s colorscheme=%s'):format(
    data.startup_ms or -1, data.plugin_count or '?', data.lsp_active or 0, data.background, data.colorscheme or 'none'
  ))
end, {})

return true
