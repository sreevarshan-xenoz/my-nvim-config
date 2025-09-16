-- ops/sys.lua
-- System info & operations (stats/update/clean)
local M = {}
local jobs = require('sree.ops.jobs')

local ALLOW = {
  git = true,
  df = true,
  free = true,
  uname = true,
}

local function run_allow(cmd, args)
  if not ALLOW[cmd] then
    return { code = -2, stdout = { 'DISALLOWED: ' .. cmd }, stderr = {} }
  end
  return jobs.run(vim.list_extend({ cmd }, args or {}))
end

local function parse_mem()
  local meminfo = {}
  local fh = io.open('/proc/meminfo', 'r')
  if not fh then return nil end
  for line in fh:lines() do
    local k, v = line:match('([^:]+):%s+(%d+)')
    if k and v then meminfo[k] = tonumber(v) end
  end
  fh:close()
  if meminfo.MemTotal and meminfo.MemAvailable then
    local used = meminfo.MemTotal - meminfo.MemAvailable
    return math.floor((used / meminfo.MemTotal) * 100)
  end
end

local function git_branch()
  local res = jobs.run({ 'git', 'rev-parse', '--abbrev-ref', 'HEAD' }, { timeout_ms = 700 })
  if res.code == 0 and res.stdout[1] and res.stdout[1] ~= '' then
    return res.stdout[1]
  end
  return 'no-git'
end

local function plugin_updates()
  local ok_lazy, lazy = pcall(require, 'lazy')
  if not ok_lazy then return 0 end
  local outdated = 0
  for _, pkg in pairs(lazy.plugins()) do
    if pkg._.update and pkg._.update.commit and pkg._.installed then outdated = outdated + 1 end
  end
  return outdated
end

function M.stats()
  local uptime = vim.loop.uptime()
  local mem = parse_mem() or -1
  local branch = git_branch()
  local updates = plugin_updates()
  local loadavg = ''
  local lf = io.open('/proc/loadavg', 'r')
  if lf then loadavg = lf:read('*l') or ''; lf:close() end
  return {
    uptime = string.format('%.1fs', uptime),
    mem_used = mem .. '%',
    git_branch = branch,
    plugin_updates = updates,
    load = loadavg:match('^[^ ]+ [^ ]+ [^ ]+') or loadavg,
  }
end

function M.update()
  return run_allow('git', { 'pull' })
end

function M.clean()
  -- placeholder: could prune lazy cache or tmp files
  return { code = 0, stdout = { 'Nothing to clean (stub)' }, stderr = {} }
end

return M
