-- test/init.lua
-- Neotest configuration and helpers
local M = {}

function M.setup()
  local neotest = require('neotest')
  neotest.setup({
    adapters = {
      require('neotest-python')({ dap = { justMyCode = false } }),
      require('neotest-go')({ experimental = { test_table = true } }),
      require('neotest-jest')({ jestCommand = 'npm test --', env = { CI = true }, cwd = function() return vim.fn.getcwd() end }),
    },
    diagnostic = { enabled = true },
    floating = { border = 'rounded' },
    summary = { open = 'botright vsplit | vertical resize 35' },
  })
end

function M.run_current()
  require('neotest').run.run()
end

function M.run_file()
  require('neotest').run.run(vim.fn.expand('%'))
end

function M.run_nearest_debug()
  require('neotest').run.run({ strategy = 'dap' })
end

function M.open_output()
  require('neotest').output.open({ enter = true, auto_close = true })
end

function M.toggle_summary()
  require('neotest').summary.toggle()
end

return M
