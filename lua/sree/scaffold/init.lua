-- scaffold/init.lua
-- :Scaffold <type> creates file(s) from template snippets
local M = {}

local templates_dir = vim.fn.stdpath('config') .. '/templates'

local function ensure_dir(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, 'p')
  end
end

local function read_template(name)
  local file = templates_dir .. '/' .. name .. '.tpl'
  if vim.fn.filereadable(file) == 0 then
    return nil, 'Template not found: ' .. name
  end
  local lines = vim.fn.readfile(file)
  return table.concat(lines, '\n')
end

local function expand_vars(content, vars)
  return (content:gsub('{{(.-)}}', function(key)
    key = vim.trim(key)
    return vars[key] or ''
  end))
end

function M.generate(type_, opts)
  opts = opts or {}
  local ok, content = read_template(type_)
  if not ok and content then
    vim.notify(content, vim.log.levels.ERROR)
    return
  end
  local vars = {
    FILE = opts.filename or ('new_' .. type_),
    DATE = os.date('%Y-%m-%d'),
    AUTHOR = os.getenv('USER') or 'user',
  }
  local expanded = expand_vars(content, vars)
  local target = vars.FILE
  if vim.fn.filereadable(target) == 1 then
    vim.notify('File exists: ' .. target, vim.log.levels.WARN)
    return
  end
  vim.fn.writefile(vim.split(expanded, '\n'), target)
  vim.cmd('edit ' .. target)
  vim.notify('Scaffolded: ' .. target)
end

function M.setup()
  ensure_dir(templates_dir)
  vim.api.nvim_create_user_command('Scaffold', function(cmd)
    local args = vim.split(cmd.args, ' ')
    local type_ = args[1]
    if not type_ or type_ == '' then
      vim.notify('Usage: :Scaffold <type> [filename]', vim.log.levels.WARN)
      return
    end
    M.generate(type_, { filename = args[2] })
  end, { nargs = '+', complete = function() return { 'lua_module', 'python_script' } end })
end

return M
