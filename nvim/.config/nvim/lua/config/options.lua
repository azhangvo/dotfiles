vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Explicit rather than relying on Neovim's terminal-capability auto-detect.
vim.o.termguicolors = true

vim.o.number = true
vim.o.relativenumber = true

-- `unnamedplus` routes yank/delete to the OS clipboard, not just nvim's
-- own internal register.
vim.o.clipboard = "unnamedplus"
