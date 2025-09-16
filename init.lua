-- Sree Neovim Config (Phase v0.1 foundation)
-- Minimal bootstrap: leader, lazy.nvim, core modules, wallbash theme stub
-- Includes early micro-profiler for startup time target (<90ms cold)

local fn = vim.fn
local start_time = vim.loop.hrtime()

-- Leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Feature flags early (will expand)
local ok_flags, flags = pcall(require, 'sree.flags')
if not ok_flags then
  -- temporary inline flags until module exists
  flags = { ai = false, embeddings = false, agent = false, voice = false, wallbash_overrides = true }
end
_G.SreeFlags = flags

-- Utility safe require
local function prequire(mod)
  local ok, m = pcall(require, mod)
  if ok then return m end
  vim.schedule(function()
    vim.notify(('Failed loading %s'):format(mod), vim.log.levels.WARN)
  end)
  return nil
end

-- Bootstrap lazy.nvim
local lazypath = fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Core options & keymaps modules will be created shortly
prequire('sree.core.options')
prequire('sree.core.keymaps')
prequire('sree.core.autocmds')

-- Plugin spec (moved to module for clarity)
local plugin_spec = prequire('sree.plugins') or {}
require('lazy').setup(plugin_spec, {
  ui = { border = 'rounded' },
  change_detection = { notify = false },
})

-- Apply theme overrides (stub)
local theme = prequire('sree.ui.theme')
if theme and theme.apply then theme.apply() end

-- Load health + util modules (non-fatal if missing)
prequire('sree.core.health')
local lsp_notify = prequire('sree.core.lsp_notify')
if lsp_notify and lsp_notify.setup then lsp_notify.setup() end

-- Require ops module if flag enabled
local ops = prequire('sree.ops')
if ops and (not SreeFlags or SreeFlags.ops ~= false) then
  pcall(function() ops.setup() end)
end

-- Basic notification if first run
vim.defer_fn(function()
  if not vim.g.__sree_boot_msg then
    vim.g.__sree_boot_msg = true
    local elapsed_ms = (vim.loop.hrtime() - start_time) / 1e6
    _G.SreeStartupMs = elapsed_ms
    vim.notify(('Sree v0.1 core loaded in %.1fms'):format(elapsed_ms), vim.log.levels.INFO)
  end
end, 120)
