-- core/whichkey.lua
-- Central registration of leader namespaces to avoid later collisions
local M = {}

local groups = {
  f = { name = '+file/find' },
  g = { name = '+git' },
  s = { name = '+system' },
  a = { name = '+ai' },
  t = { name = '+test' },
  d = { name = '+debug' },
  c = { name = '+code' },
  o = { name = '+ops' },
}

function M.register(wk)
  wk.register(groups, { prefix = '<leader>' })
end

return M
