-- ops/redact.lua
-- Redaction utilities for masking secrets in command output
local M = {}

local patterns = {
  'AWS_[A-Z_]+=[%w%p]+',
  'GITHUB_TOKEN=[%w%p]+',
  'SECRET_KEY=[%w%p]+',
  'AUTH_TOKEN=[%w%p]+',
}

local function mask(kv)
  return kv:gsub('=.+', '=***')
end

function M.filter(lines)
  local out = {}
  for _, l in ipairs(lines) do
    local replaced = l
    for _, pat in ipairs(patterns) do
      replaced = replaced:gsub(pat, mask)
    end
    table.insert(out, replaced)
  end
  return out
end

return M
