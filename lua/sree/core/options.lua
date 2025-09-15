-- core/options.lua
-- Editor option baseline migrated from legacy vimscript + modern sane defaults
local opt = vim.opt

-- Indentation & tabs
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = 'yes'
opt.splitbelow = true
opt.splitright = true
opt.wrap = false
opt.showmode = false
opt.cmdheight = 1

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Performance
opt.updatetime = 300
opt.timeoutlen = 400
opt.lazyredraw = true

-- Completion / wildmenu modernization
opt.wildmode = 'longest:full,full'
opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- Misc
opt.clipboard = 'unnamedplus'
opt.mouse = 'a'
opt.swapfile = false
opt.hidden = true
opt.scrolloff = 4
opt.sidescrolloff = 5

-- Colorcolumn placeholder for future flags
-- opt.colorcolumn = '100'

return true
