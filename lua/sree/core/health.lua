-- core/health.lua
-- :SreeHealth command summarizing core modules, flags, startup, plugins
local util = require('sree.core.util')
local flags = require('sree.flags')

local function lsp_server_count()
  local clients = vim.lsp.get_active_clients and vim.lsp.get_active_clients() or {}
  return #clients
end

local function tool_present(bin)
  return vim.fn.executable(bin) == 1
end

local function test_status()
  if not util.safe_require('neotest') then return 'inactive' end
  return 'ok'
end

local function overseer_status()
  if not util.safe_require('overseer') then return 'inactive' end
  return 'ok'
end

local function ops_status()
  return package.loaded['sree.ops'] and 'ok' or 'inactive'
end

local function embeddings_status()
  if not flags.embeddings then return 'disabled' end
  return package.loaded['sree.embeddings'] and 'ok' or 'inactive'
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
    test = test_status(),
    tasks = overseer_status(),
    fmt_tools = {
      stylua = tool_present('stylua'),
      prettierd = tool_present('prettierd'),
      black = tool_present('black'),
      gofumpt = tool_present('gofumpt'),
      rustfmt = tool_present('rustfmt'),
    }
  }
end

util.command('SreeHealth', function()
  local data = collect()
  local ops = ops_status()
  vim.notify(('[SreeHealth] startup=%.1fms plugins=%s lsp=%d test=%s tasks=%s ops=%s colorscheme=%s'):format(
    data.startup_ms or -1, data.plugin_count or '?', data.lsp_active or 0, data.test, data.tasks, ops, data.colorscheme or 'none'
  ))
end, {})

-- Provide a lightweight status accessor for other modules
package.loaded['sree.core.health.embeddings_status'] = embeddings_status

return true
