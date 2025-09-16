-- ops/dashboard.lua
-- Basic 3-pane layout toggle (metrics | logs | alerts placeholder)
local M = {}

local state = { open = false, saved = nil }

local function open_layout()
  state.saved = { tab = vim.api.nvim_get_current_tabpage(), win = vim.api.nvim_get_current_win() }
  vim.cmd('tabnew')
  vim.cmd('vsplit')
  vim.cmd('split')
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local metrics = wins[1]
  local logs = wins[2]
  local alerts = wins[3]
  vim.api.nvim_set_current_win(metrics)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { '== Metrics ==' })
  vim.api.nvim_set_current_win(logs)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { '== Logs (future tail) ==' })
  vim.api.nvim_set_current_win(alerts)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { '== Alerts (pattern matches) ==' })
  state.open = true
end

local function close_layout()
  if state.open then
    vim.cmd('tabclose')
    state.open = false
  end
end

function M.toggle()
  if state.open then close_layout() else open_layout() end
end

return M
