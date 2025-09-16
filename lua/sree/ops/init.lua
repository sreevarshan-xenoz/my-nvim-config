-- ops/init.lua
-- Entry point for ops layer
local M = {}
local sys = require('sree.ops.sys')
local dashboard = require('sree.ops.dashboard')

function M.setup()
  vim.api.nvim_create_user_command('Sys', function(cmd)
    local sub = cmd.fargs[1]
    if sub == 'stats' then
      local s = sys.stats()
      vim.notify(string.format('[Sys] uptime=%s mem=%s branch=%s updates=%d load=%s', s.uptime, s.mem_used, s.git_branch, s.plugin_updates, s.load))
    elseif sub == 'update' then
      local res = sys.update(); vim.notify('[Sys update] code=' .. res.code)
    elseif sub == 'clean' then
      local res = sys.clean(); vim.notify('[Sys clean] ' .. table.concat(res.stdout, ' '))
    else
      vim.notify('Usage: :Sys <stats|update|clean>', vim.log.levels.WARN)
    end
  end, { nargs = 1, complete = function() return { 'stats', 'update', 'clean' } end })

  vim.api.nvim_create_user_command('OpsToggle', function()
    dashboard.toggle()
  end, {})
end

return M
