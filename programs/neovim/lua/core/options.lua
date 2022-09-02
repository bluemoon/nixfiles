local o = vim.opt

-- Leader
vim.g.mapleader = ","

vim.opt.termguicolors = true
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.cmdheight = 2
vim.opt.cursorline = true                       -- highlight the current line
vim.opt.fileencoding = "utf-8"
vim.opt.showtabline = 2                         -- always show tabs
vim.opt.smartcase = true                        -- smart case
vim.opt.smartindent = true                      -- make indenting smarter again
vim.opt.number = true                           -- set number column width to 2 {default 4}
vim.opt.numberwidth = 4                         -- set number column width to 2 {default 4}
vim.opt.signcolumn = "yes"                      -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false                            -- wrap off

-- Tabs
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.copyindent = true

-- Remove builtin plugins
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_zip = 1
