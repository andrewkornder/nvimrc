-- line #s
vim.o.nu = true

vim.o.virtualedit = "onemore"

-- indent size
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true

-- search settings
vim.o.hlsearch = false
vim.o.incsearch = true

vim.o.scrolloff = 8
vim.o.signcolumn = "yes"

vim.opt.isfname:append("@-@")

vim.o.updatetime = 50
vim.o.colorcolumn = "80"

vim.o.autochdir = false

vim.o.textwidth = 60
vim.o.wrap = false

vim.g.netrw_sizestyle = "h"
vim.g.netrw_liststyle = 1
vim.g.netrw_sort_by = "exten"

vim.g.python3_host_prog = vim.user.python

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.cmd("set textwidth=0")
vim.cmd("set nohidden")
