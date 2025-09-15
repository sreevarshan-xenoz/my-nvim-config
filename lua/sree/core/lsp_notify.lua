-- core/lsp_notify.lua
-- Future LSP message routing & diagnostic notification normalization
local M = {}

function M.setup()
  -- Defer until LSP actually loads; safe to call early
  local ok_notify, _ = pcall(require, 'notify')
  if not ok_notify then return end
  -- Example handler override (when LSP configured later)
  vim.lsp.handlers['window/showMessage'] = function(err, method, params, client_id)
    local severity = ({ 'ERROR', 'WARN', 'INFO', 'INFO' })[params.type] or 'INFO'
    vim.notify(('LSP(%s): %s'):format(client_id or '?', params.message), vim.log.levels[severity])
  end
end

return M
