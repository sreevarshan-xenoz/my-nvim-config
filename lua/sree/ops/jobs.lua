-- ops/jobs.lua
-- Job abstraction with timeout + redaction
local M = {}
local redact = require('sree.ops.redact')

local function collect_output(obj)
  local stdout = table.concat(obj.stdout, '\n')
  local stderr = table.concat(obj.stderr, '\n')
  return stdout, stderr
end

--- Run a command safely (allowlisted externally)
-- @param cmd table: command + args
-- @param opts table: { timeout_ms }
function M.run(cmd, opts)
  opts = opts or {}
  local timeout = opts.timeout_ms or 1500
  local result = { code = nil, stdout = {}, stderr = {} }
  local handle = vim.system(cmd, { text = true }, function(obj)
    result.code = obj.code
    result.stdout = vim.split(obj.stdout or '', '\n')
    result.stderr = vim.split(obj.stderr or '', '\n')
  end)

  local start = vim.loop.hrtime()
  while result.code == nil do
    if ((vim.loop.hrtime() - start) / 1e6) > timeout then
      handle:kill('sigterm')
      return { code = -1, stdout = { 'TIMEOUT' }, stderr = {} }
    end
    vim.wait(10)
  end
  result.stdout = redact.filter(result.stdout)
  result.stderr = redact.filter(result.stderr)
  return result
end

return M
