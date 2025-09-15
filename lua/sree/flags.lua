-- flags.lua
-- Central feature flags (early load)
local M = {
  ai = false,
  embeddings = false,
  agent = false,
  voice = false,
  ops = false,
  wallbash_overrides = true,
}

function M.is_enabled(flag)
  return M[flag] == true
end

function M.enable(flag) M[flag] = true end
function M.disable(flag) M[flag] = false end

return M
