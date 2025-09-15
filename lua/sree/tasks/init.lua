-- tasks/init.lua
-- Overseer task runner configuration
local M = {}

function M.setup()
  local overseer = require('overseer')
  overseer.setup({
    strategy = { 'toggleterm', open_on_start = false },
    templates = { 'builtin', 'user.sree' },
  })
end

function M.run_build()
  require('overseer').run_template({ name = 'Build' })
end

function M.run_test()
  require('overseer').run_template({ name = 'Test' })
end

return M
