-- embeddings/init.lua
-- Phase 6 minimal skeleton: indexing + querying interface (no provider yet)
local M = {}

local state = {
  chunks = 0,
  last_index_time = nil,
  status = 'idle', -- idle|indexing|error
  store_path = vim.fn.stdpath('data') .. '/sree/embeddings.json',
}

-- Simple chunking strategy (line groups) placeholder
local function chunk_buffer(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local chunks = {}
  local block = {}
  local max_lines = 40
  for i,l in ipairs(lines) do
    block[#block+1] = l
    if #block >= max_lines then
      chunks[#chunks+1] = table.concat(block, '\n')
      block = {}
    end
  end
  if #block > 0 then
    chunks[#chunks+1] = table.concat(block, '\n')
  end
  return chunks
end

local function scan_project()
  local root = vim.loop.cwd()
  local patterns = {'.lua', '.py', '.ts', '.js', '.go', '.rs', '.md', '.txt'}
  local results = {}
  local function is_match(name)
    for _,ext in ipairs(patterns) do
      if name:sub(-#ext) == ext then return true end
    end
    return false
  end
  local function walk(dir)
    local fd = vim.loop.fs_scandir(dir)
    if not fd then return end
    while true do
      local name, t = vim.loop.fs_scandir_next(fd)
      if not name then break end
      if name:sub(1,1) == '.' then goto continue end
      local full = dir .. '/' .. name
      if t == 'file' and is_match(name) then
        results[#results+1] = full
      elseif t == 'directory' then
        walk(full)
      end
      ::continue::
    end
  end
  walk(root)
  return results
end

local function load_store()
  local ok, data = pcall(vim.fn.readfile, state.store_path)
  if not ok or not data or #data == 0 then return {} end
  local decoded = vim.json.decode(table.concat(data, '\n'))
  return decoded or {}
end

local function save_store(store)
  local encoded = vim.json.encode(store)
  vim.fn.mkdir(vim.fn.fnamemodify(state.store_path, ':h'), 'p')
  vim.fn.writefile(vim.split(encoded, '\n'), state.store_path)
end

-- placeholder embed: hash lines -> numeric vector using simple rolling hash
local function fake_embed(text)
  local sum = 0
  for i=1,#text do sum = (sum * 131 + text:byte(i)) % 1000000007 end
  -- produce small fixed-size vector by splitting sum
  local vec = { (sum % 1000) / 1000, (sum % 10000)/10000, (sum % 100000)/100000, (sum % 1000000)/1000000 }
  return vec
end

local function distance(a,b)
  local d = 0
  for i=1,math.min(#a,#b) do
    local diff = a[i]-b[i]
    d = d + diff*diff
  end
  return math.sqrt(d)
end

function M.index(opts)
  opts = opts or {}
  if state.status == 'indexing' then
    vim.notify('[Embeddings] already indexing', vim.log.levels.WARN)
    return
  end
  state.status = 'indexing'
  local store = { items = {} }
  local files = scan_project()
  local total_chunks = 0
  for _,file in ipairs(files) do
    local bufnr = vim.fn.bufadd(file)
    vim.fn.bufload(bufnr)
    local chunks = chunk_buffer(bufnr)
    for ci,chunk in ipairs(chunks) do
      total_chunks = total_chunks + 1
      store.items[#store.items+1] = {
        file = file,
        chunk_index = ci,
        text = chunk,
        vector = fake_embed(chunk),
      }
    end
  end
  save_store(store)
  state.chunks = total_chunks
  state.last_index_time = os.time()
  state.status = 'idle'
  vim.notify(('[Embeddings] indexed %d chunks from %d files'):format(total_chunks, #files))
end

function M.query(q)
  if not q or q == '' then
    vim.notify('[Embeddings] empty query', vim.log.levels.WARN)
    return
  end
  local store = load_store()
  if not store.items or #store.items == 0 then
    vim.notify('[Embeddings] store empty; run :EmbedIndex', vim.log.levels.WARN)
    return
  end
  local qvec = fake_embed(q)
  local scored = {}
  for _,item in ipairs(store.items) do
    local d = distance(qvec, item.vector)
    scored[#scored+1] = { dist = d, item = item }
  end
  table.sort(scored, function(a,b) return a.dist < b.dist end)
  local max = math.min(20, #scored)
  local qf = {}
  for i=1,max do
    local s = scored[i]
    qf[#qf+1] = {
      filename = s.item.file,
      lnum = 1,
      col = 1,
      text = ('[%.4f] %s'):format(s.dist, (s.item.text:gsub('\n',' '):sub(1,120)))
    }
  end
  vim.fn.setqflist({}, ' ', { title = 'Embedding Query: ' .. q, items = qf })
  vim.cmd('copen')
end

function M.status()
  local t = state.last_index_time and os.date('%Y-%m-%d %H:%M:%S', state.last_index_time) or 'never'
  vim.notify(('[Embeddings] status=%s chunks=%d last=%s store=%s'):format(state.status, state.chunks, t, state.store_path))
end

function M.setup()
  vim.api.nvim_create_user_command('EmbedIndex', function() M.index() end, {})
  vim.api.nvim_create_user_command('EmbedQuery', function(opts) M.query(table.concat(opts.fargs, ' ')) end, { nargs = '+' })
  vim.api.nvim_create_user_command('EmbedStatus', function() M.status() end, {})
end

return M
