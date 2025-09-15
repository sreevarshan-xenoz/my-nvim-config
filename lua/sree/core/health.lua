-- core/health.lua
-- :SreeHealth command summarizing core modules, flags, startup, plugins
local util = require('sree.core.util')
local flags = require('sree.flags')

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
  }
end

util.command('SreeHealth', function()
  local data = collect()
  vim.notify(('[SreeHealth] startup=%.1fms plugins=%s bg=%s colorscheme=%s'):format(
    data.startup_ms or -1, data.plugin_count or '?', data.background, data.colorscheme or 'none'
  ))
end, {})

return true
