-- line #s
vim.opt.rnu = true

vim.opt.virtualedit = "onemore"

-- indent size
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- search settings
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"

vim.opt.autochdir = false

vim.opt.textwidth = 60
vim.opt.wrap = false

vim.g.netrw_sizestyle = "h"
vim.g.netrw_liststyle = 1
vim.g.netrw_sort_by = "exten"

vim.g.python3_host_prog = vim.user.python

vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.opt.textwidth = 0
vim.opt.hidden = false
