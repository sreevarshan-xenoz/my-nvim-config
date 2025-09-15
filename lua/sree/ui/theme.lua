-- ui/theme.lua
-- Wallbash translation (initial stub). Later: adaptive + palette management.
local M = {}

local function detect_background()
  local env_bg = vim.env.BACKGROUND
  if env_bg and env_bg:lower():match('light') then
    return 'light'
  end
  return 'dark'
end

local palette = {
  dark = {
    fg = '#FFFFFF',
    bg = 'NONE',
    accent1 = '#CCD2FF',
    accent2 = '#9AA2E6',
    dim = '#434C6A',
  },
  light = {
    fg = '#16171F',
    bg = 'NONE',
    accent1 = '#293052',
    accent2 = '#4B547D',
    dim = '#FFFFFF',
  },
}

local function apply_core(pal)
  local set = vim.api.nvim_set_hl
  set(0, 'Normal', { fg = pal.fg, bg = pal.bg })
  set(0, 'SignColumn', { bg = pal.bg })
  set(0, 'StatusLine', { fg = pal.fg, bg = pal.dim })
  set(0, 'StatusLineNC', { fg = pal.fg, bg = pal.bg })
  set(0, 'Visual', { fg = '#16171F', bg = pal.accent2, bold = true })
  set(0, 'LineNr', { fg = pal.accent2, bg = pal.bg })
  set(0, 'CursorLineNr', { fg = pal.accent1, bold = true })
  set(0, 'Search', { fg = '#16171F', bg = pal.accent1 })
  set(0, 'IncSearch', { fg = '#16171F', bg = pal.accent1 })
  set(0, 'Pmenu', { fg = pal.fg, bg = pal.dim })
  set(0, 'PmenuSel', { fg = '#16171F', bg = pal.accent1, bold = true })
end

function M.apply()
  local bg = detect_background()
  vim.o.background = bg
  local pal = palette[bg]
  apply_core(pal)
  if require('sree.flags').is_enabled('wallbash_overrides') then
    -- placeholder for extended plugin highlight sets (later modularized)
  end
end

function M.refresh()
  M.apply()
end

return M
